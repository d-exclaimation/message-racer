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
  alias MessageRacer.Race.{Room, Player}
  alias MessageRacer.{RoomMutations, RoomQueries, PlayerMutations}
  alias MessageRacerWeb.Graph
  import MessageRacerWeb.Graph, only: [ok: 1, error: 1]

  import_types(MessageRacerWeb.RoomSchema)

  object :room_mutations do
    @desc "Create a new room"
    field :create_room, :room do
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

    @desc ""
    field :send, :player do
      arg(:movement, non_null(:game_change))

      # TODO: Connect to client and set up subscription

      aaaaaaaaaaaaaaaaaaaaaaaaaa(fix(me))

      resolve(fn %{movement: m}, %{context: ctx} ->
        IO.inspect(m)
        {:ok, Map.get(ctx, :user)}
      end)
    end
  end

  object :room_queries do
    @desc "Get all public rooms"
    field :available_rooms, non_null(list_of(non_null(:room))) do
      arg(:last, non_null(:integer))
      resolve(&available_rooms/2)
    end
  end

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
         {:ok, user} <- PlayerMutations.create_player(uuid, info) do
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
