#
#  player_mutations.ex
#  server
#
#  Created by d-exclaimation on 18:17.
#

defmodule MessageRacer.PlayerMutations do
  @moduledoc """
  Mutation related to Players
  """
  alias MessageRacer.Race.Player
  alias MessageRacer.Repo

  @doc """
  Create a player and assign them to a room
  """
  @spec create_player(Ecto.UUID.t(), map()) :: {:ok, %Player{}} | {:error, Ecto.Changeset.t()}
  def create_player(room_id, %{username: username}) do
    %Player{room_id: room_id}
    |> Player.changeset(%{"username" => username})
    |> Repo.insert()
  end
end
