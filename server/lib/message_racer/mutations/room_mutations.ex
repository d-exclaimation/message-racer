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
  alias MessageRacer.{Race.Room, Repo, RoomQueries}

  @doc """
  Create a new room
  """
  @spec create(map()) :: {:ok, Room.t()} | {:error, Ecto.Changeset.t()}
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

  @doc """
  Delete a room
  """
  @spec clear_room(Ecto.UUID.t()) :: {:ok, Room.t()} | {:error, Ecto.Changeset.t()}
  def clear_room(id) do
    try do
      Room
      |> Repo.get!(id)
      |> Repo.delete()
    rescue
      Ecto.NoResultsError -> {:error, %Ecto.Changeset{errors: [id: "invalid"]}}
    end
  end

  @doc """
  Add to count
  """
  @spec increment_count(Ecto.UUID.t()) :: {:ok, integer()} | {:error, String.t()}
  def increment_count(id) do
    with %Room{player_count: old_count} = room <- RoomQueries.get_count(id),
         {:ok, %Room{player_count: new_count}} <- do_increment(room, old_count) do
      {:ok, new_count}
    else
      {:error, %Ecto.Changeset{errors: err}} -> {:error, inspect(err)}
      _ -> {:error, "Invalid id"}
    end
  end

  defp do_increment(_, old_count) when old_count >= 4,
    do: {:error, %Ecto.Changeset{errors: [{:player_count, "full room"}]}}

  defp do_increment(room, old_count),
    do: room |> Ecto.Changeset.change(%{player_count: old_count + 1}) |> Repo.update()
end
