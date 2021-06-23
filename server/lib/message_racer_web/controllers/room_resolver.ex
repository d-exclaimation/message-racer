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
  import MessageRacerWeb.Graph, only: [ok: 1, error: 1]
  alias MessageRacer.Race.{Room, Player}
  alias MessageRacer.{RoomMutations, RoomQueries, PlayerMutations}
  alias MessageRacerWeb.{Graph, Event}

  import_types(MessageRacerWeb.RoomSchema)
  import_types(MessageRacerWeb.GameSchema)

  @type game_event :: Event.Delta.t() | Event.End.t() | Event.Join.t() | Event.Start.t()

  object :room_mutations do
    @desc "Create a new room"
    field :create_room, :room do
      arg(:user_info, non_null(:join_input))
      resolve(&create_room/2)
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
      config(fn %{room_id: room_id}, _ -> {:ok, topic: room_id} end)

      # TODO: Contemplating splitting into a couple subscriptions, but that might be expensive, need to check whether client can batch websockets together
      resolve(&game_cycle/3)
    end
  end

  @doc """
  Send game changes
  """
  @spec send_changes(%{delta: map()}, Absinthe.Resolution.t()) :: Graph.returned(boolean())
  def send_changes(
        %{delta: %{changes: %{index: i, word: word}, room_id: id, username: username}},
        %Absinthe.Resolution{
          context: _ctx
        }
      ) do
    Graph.dispatch(
      %Event.Delta{index: i, word: word, username: username, type: :delta},
      game_cycle: id
    )

    true |> ok()
  end

  def send_changes(_args, _res), do: false |> ok()

  @doc """
  Game cycle subscriptions
  """
  @spec game_cycle(map(), map(), Absinthe.Resolution.t()) :: Graph.returned(game_event())
  def game_cycle(p, _, _), do: p |> ok()

  @doc """
  Create room resolver
  """
  @spec create_room(map(), Absinthe.Resolution.t()) :: Graph.returned(%Room{})
  def create_room(_args, _res) do
    case RoomMutations.create(%{}) do
      {:ok, %Room{} = room} ->
        room
        |> ok()

      {:error, %Ecto.Changeset{errors: errors}} ->
        errors
        |> inspect()
        |> error()
    end
  end

  @doc """
  Join room
  """
  @spec join_room(%{user_info: map(), room_id: String.t()}, Absinthe.Resolution.t()) ::
          Graph.returned(%Player{})
  def join_room(%{user_info: info, room_id: id}, _res) do
    with {:ok, uuid} <- Ecto.UUID.cast(id),
         {:ok, %Player{username: username} = user} <- PlayerMutations.create_player(uuid, info) do
      Graph.dispatch(
        %Event.Join{type: :join, username: username},
        game_cycle: uuid
      )

      # TODO: Give all initial info here
      user |> ok()
    else
      _ -> "Cannot find room" |> error()
    end
  end

  @doc """
  Query all available rooms
  """
  @spec available_rooms(map(), Absinthe.Resolution.t()) :: Graph.returned([%Room{}])
  def available_rooms(%{last: last}, _res) do
    last
    |> RoomQueries.available()
    |> ok()
  end

  def available_rooms(_args, _res), do: "Required parameter last not given" |> error()

  # Add session to context, to be fetch in the Blueprint
  @spec setup_auth(Absinthe.Resolution.t(), any()) :: Absinthe.Resolution.t()
  defp setup_auth(%Absinthe.Resolution{value: %Player{id: id}} = res, _conf) do
    res
    |> Map.update(:context, %{}, &Map.merge(&1, %{session_id: id}))
  end

  defp setup_auth(res, _conf), do: res
end
