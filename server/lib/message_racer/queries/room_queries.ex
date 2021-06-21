#
#  room_queries.ex
#  server
#
#  Created by d-exclaimation on 13:26.
#

defmodule MessageRacer.RoomQueries do
  @moduledoc """
  Room based queries
  """
  import Ecto.Query, only: [from: 2]
  alias MessageRacer.Race.Room
  alias MessageRacer.Repo

  @doc """
  Get all available rooms
  """
  @spec available(integer()) :: [%Room{}]
  def available(limit) do
    from(
      room in Room,
      order_by: [desc: room.inserted_at],
      limit: ^limit
    )
    |> Repo.all()
  end

  @doc """
  Get all available rooms
  """
  @spec get(Ecto.UUID.t()) :: %Room{} | nil
  def get(id) do
    Room
    |> Repo.get(id)
  end
end
