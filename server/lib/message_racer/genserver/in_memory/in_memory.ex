#
#  InMemory.ex
#  server
#
#  Created by d-exclaimation on 16:32.
#

defmodule MessageRacer.InMemory do
  @moduledoc """
  Client API for InMemory
  """
  alias MessageRacer.InMemory.Store

  @doc """
  Validate in InMemory
  """
  @spec validate(String.t(), integer(), String.t()) :: String.t()
  def validate(id, index, word) do
    GenServer.call(Store, {:check, %{id: id, index: index, word: word}})
  end

  @doc """
  Start a new game and add to InMemory
  """
  @spec start(String.t()) :: [String.t()]
  def start(id) do
    GenServer.call(Store, {:start, id})
  end
end
