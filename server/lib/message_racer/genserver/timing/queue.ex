#
#  task_queue.ex
#  server
#
#  Created by d-exclaimation on 12:59.
#

defmodule Timing.Queue do
  @moduledoc """
  GenServer for handling Timings
  """
  use GenServer

  @typedoc """
  Function references
  """
  @type task_ref :: String.t()

  @typedoc """
  Timing type: Function with side effects
  """
  @type task :: function()

  @typedoc """
  Timing Queue Internal state
  """
  @type state :: MapSet.t(task_ref())

  @type interval_call :: {:reply, task_ref(), state()}

  @doc """
  Start the Timing genserver
  """
  @spec start_link(GenServer.options()) :: GenServer.on_start()
  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @doc """
  Initial callback
  """
  @impl true
  @spec init(:ok) :: {:ok, state()}
  def init(:ok) do
    {:ok, MapSet.new()}
  end

  @doc """
  Handle setting up all the given async / non block Timings
  """
  @impl true
  @spec handle_cast({:timeout, task, integer()}, state()) :: {:noreply, state()}
  def handle_cast({:timeout, fun, time}, state) do
    # Append ref into state and call send_after
    ref = "timeout:" <> inspect(fun) <> (DateTime.utc_now() |> DateTime.to_string())

    if state |> MapSet.member?(ref) do
      {:noreply, state}
    else
      Process.send_after(self(), {:timeout, fun, ref}, time)
      {:noreply, state |> MapSet.put(ref)}
    end
  end

  @spec handle_cast({:clear, task_ref}, state()) :: {:noreply, state()}
  def handle_cast({:clear, ref}, state),
    do: {:noreply, state |> MapSet.delete(ref)}

  @doc """
  Handla all sync Timings
  """
  @impl true
  @spec handle_call({:interval, task, integer()}, any(), state()) :: interval_call()
  def handle_call({:interval, fun, time}, _from, state) do
    # Append ref into state and call send_after
    ref = "interval:" <> inspect(fun) <> (DateTime.utc_now() |> DateTime.to_string())

    if state |> MapSet.member?(ref) do
      {:reply, ref, state}
    else
      Process.send_after(self(), {:inteval, fun, ref, time}, time)
      {:reply, ref, state |> MapSet.put(ref)}
    end
  end

  @spec handle_call({:timeout, task, integer()}, any(), state()) :: interval_call()
  def handle_call({:timeout, fun, time}, _from, state) do
    # Append ref into state and call send_after
    ref = "timeout:" <> inspect(fun) <> (DateTime.utc_now() |> DateTime.to_string())

    if state |> MapSet.member?(ref) do
      {:reply, ref, state}
    else
      Process.send_after(self(), {:timeout, fun, ref}, time)
      {:reply, ref, state |> MapSet.put(ref)}
    end
  end

  @doc """
  Handle callback message from other process
  """
  @impl true
  @spec handle_info({:timeout, Timing, task_ref}, state()) :: {:noreply, state()}
  def handle_info({:timeout, fun, ref}, state) do
    if state |> MapSet.member?(ref) do
      fun.()
      {:noreply, state |> MapSet.delete(ref)}
    else
      {:noreply, state}
    end
  end

  @spec handle_info({:interval, Timing, task_ref, integer()}, state()) :: {:noreply, state()}
  def handle_info({:inteval, fun, ref, time}, state) do
    if state |> MapSet.member?(ref) do
      fun.()
      Process.send_after(self(), {:interval, fun, ref, time}, time)
      {:noreply, state}
    else
      {:noreply, state}
    end
  end
end
