#
#  room_resolver.ex
#  server
#
#  Created by d-exclaimation on 12:23.
#

defmodule MessageRacerWeb.RoomResolver do
  @moduledoc """
  Room GraphQL Resolver
  """
  use Absinthe.Schema.Notation
  import MessageRacerWeb.Graph, only: [ok: 1, error: 1, ok_auth: 2]
  alias Absinthe.Resolution, as: Res
  alias MessageRacer.{RoomMutations, RoomQueries, PlayerMutations, Race, InMemory}
  alias Race.{Room, Player}
  alias MessageRacerWeb.{Graph, Event}
  alias Event.{Delta, Start, End}

  import_types(MessageRacerWeb.RoomSchema)
  import_types(MessageRacerWeb.GameSchema)

  @type game_event :: Delta.t() | End.t() | Start.t()

  object :room_mutations do
    @desc "Create a new room"
    field :create_room, non_null(:host_info) do
      arg(:user_info, non_null(:join_input))
      resolve(&create_room/2)

      # Setup for session auth
      middleware(&setup_auth/2)
    end

    @desc "Join a room with a player information"
    field :join_room, non_null(:player) do
      arg(:user_info, non_null(:join_input))
      arg(:room_id, non_null(:id))
      resolve(&join_room/2)

      # Setup for session auth
      middleware(&setup_auth/2)
    end

    @desc "Send delta event"
    field :send_delta, :boolean do
      arg(:delta, non_null(:delta_input))
      resolve(&send_changes/2)
    end
  end

  object :room_queries do
    @desc "Get all public rooms"
    field :available_rooms, non_null(list_of(non_null(:room))) do
      arg(:last, non_null(:integer))
      resolve(&available_rooms/2)
    end
  end

  object :room_subscriptions do
    @desc "Game cycle update"
    field :game_cycle, non_null(:game_event) do
      arg(:room_id, non_null(:id))

      config(fn
        %{room_id: room_id}, _ ->
          IO.puts(room_id)
          {:ok, topic: room_id}

        _, _ ->
          {:ok, topic: "lobby"}
      end)

      resolve(&game_cycle/3)
    end
  end

  @doc """
  Send game changes
  """
  @spec send_changes(%{delta: map()}, Res.t()) :: Graph.returned(boolean())
  def send_changes(
        %{delta: %{changes: %{index: i, word: word}, room_id: id, username: username}},
        %Res{context: %{user: %Player{username: playername}}}
      )
      when playername == username do
    # Check to InMemory State, to whether it is correct, fail or a winner is found
    case InMemory.validate(id, i, word) do
      # If pass, just broadcast / dispatch to all client
      "pass" ->
        Graph.dispatch(
          %Delta{index: i, word: word, username: username, type: :delta},
          game_cycle: id
        )

        true |> ok()

      "end" ->
        # If a winner is found, then clear room as the game is over
        with {:ok, uuid} <- Ecto.UUID.cast(id),
             {:ok, %Room{}} <- RoomMutations.clear_room(uuid) do
          Graph.dispatch(
            %End{type: :end, winner: playername},
            game_cycle: id
          )

          true |> ok()
        else
          _ -> false |> ok()
        end

      _ ->
        false |> ok()
    end
  end

  def send_changes(_args, _res), do: false |> ok()

  @doc """
  Game cycle subscriptions
  """
  @spec game_cycle(map(), map(), Res.t()) :: Graph.returned(game_event())
  def game_cycle(p, _, _), do: p |> tap(&IO.inspect/1) |> ok()

  @doc """
  Create room resolver
  """
  @spec create_room(%{user_info: map()}, Res.t()) :: Graph.returned(Room.t())
  def create_room(%{user_info: info}, _res) do
    with {:ok, %Room{id: room_id} = room} <- RoomMutations.create(%{"player_count" => 1}),
         {:ok, %Player{} = user} <- PlayerMutations.create_player(room_id, info) do
      %{room: room, host: user}
      |> ok_auth(user)
    else
      {:error, %Ecto.Changeset{errors: errors}} ->
        errors
        |> inspect()
        |> error()
    end
  end

  @doc """
  Join room
  """
  @spec join_room(%{user_info: map(), room_id: String.t()}, Res.t()) :: Graph.returned(Player.t())
  def join_room(%{user_info: info, room_id: id}, _res) do
    with {:ok, uuid} <- Ecto.UUID.cast(id),
         {:ok, players} <- RoomMutations.increment_count(uuid),
         {:ok, %Player{} = user} <- PlayerMutations.create_player(uuid, info) do
      # Only send start event once there are 4 players
      if players == 4 do
        Timing.async_timeout(5000, fn ->
          payload = InMemory.start(id)
          Graph.dispatch(%Start{type: :start, payload: payload, id: uuid}, game_cycle: id)
        end)
      end

      user
      |> ok_auth(user)
    else
      :error -> "Invalid UUID" |> error()
      {:error, %Ecto.Changeset{errors: err}} -> inspect(err) |> error()
      _ -> "Cannot find room or room is full" |> error()
    end
  end

  @doc """
  Query all available rooms
  """
  @spec available_rooms(map(), Res.t()) :: Graph.returned([Room.t()])
  def available_rooms(%{last: last}, _res) do
    last
    |> RoomQueries.available()
    |> ok()
  end

  def available_rooms(_args, _res), do: "Required parameter last not given" |> error()

  # Add session to context, to be fetch in the Blueprint
  @spec setup_auth(Res.t(), any()) :: Res.t()
  defp setup_auth(%Res{value: %{auth: %Player{id: id}, value: payload}} = res, _conf) do
    res
    |> Map.update(:value, payload, fn _ -> payload end)
    |> Map.update(:context, %{}, &Map.merge(&1, %{session_id: id}))
  end

  defp setup_auth(res, _conf), do: res
end
