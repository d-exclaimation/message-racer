#
#  supervisor.ex
#  server
#
#  Created by d-exclaimation on 16:59.
#

defmodule MessageRacer.InMemory.Supervisor do
  @moduledoc """
  Supervisor for InMemory
  """
  use Supervisor

  @doc """
  Start link of this module
  """
  @spec start_link(GenServer.options()) :: GenServer.on_start()
  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  @doc """
  Handle Initializer
  """
  @impl true
  def init(:ok) do
    child = [
      {MessageRacer.InMemory.Store, []}
    ]

    Supervisor.init(child, strategy: :one_for_one)
  end
end
