#
#  player_queries.ex
#  server
#
#  Created by d-exclaimation on 16:29.
#

defmodule MessageRacer.PlayerQueries do
  @moduledoc """
  Player related queries
  """
  alias MessageRacer.Race.Player
  alias MessageRacer.Repo
  import Ecto.Query, only: [from: 2]

  @doc """
  Get all players
  """
  @spec all([Ecto.UUID.t()]) :: [%Player{}]
  def all(room_ids) do
    from(
      p in Player,
      where: p.room_id in ^room_ids
    )
    |> Repo.all()
  end
end
