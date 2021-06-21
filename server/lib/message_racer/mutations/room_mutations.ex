#
#  room.ex
#  server
#
#  Created by d-exclaimation on 13:12.
#

defmodule MessageRacer.RoomMutations do
  @moduledoc """
  Room Based mutations
  """
  alias MessageRacer.{Race.Room, Repo}

  @doc """
  Create a new room
  """
  @spec create(map()) :: {:ok, %Room{}} | {:error, Ecto.Changeset.t()}
  def create(room_attr) do
    res =
      %Room{}
      |> Room.changeset(room_attr)
      |> Repo.insert()

    case res do
      {:ok, room} ->
        {:ok, Repo.preload(room, :race_players)}

      failure ->
        failure
    end
  end
end
