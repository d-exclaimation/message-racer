defmodule Timing.Supervisor do
  @moduledoc """
  Timing Queue Supervisor
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
      {Timing.Queue, []}
    ]

    Supervisor.init(child, strategy: :one_for_one)
  end
end
