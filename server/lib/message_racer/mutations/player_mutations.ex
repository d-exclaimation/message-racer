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

  @doc """
  """
  @spec create_player(Ecto.UUID.t(), map()) :: {:ok, %Player{}} | {:error, Ecto.Changeset.t()}
  def create_player(room_id, %{username: username}) do
    {:ok, %Player{id: "peepee", room_id: room_id, username: username}}
  end
end
