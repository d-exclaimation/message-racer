#
#  event.ex
#  server
#
#  Created by d-exclaimation on 13:34.
#

defmodule Timing do
  @moduledoc """
  TimingQueue Client
  """
  @second 1000

  @doc """
  Set timeout concurrently, this is non blocking
  """
  @spec async_timeout(function()) :: :ok
  def async_timeout(fun),
    do: GenServer.cast(Timing.Queue, {:timeout, fun, @second})

  @spec async_timeout(integer(), function()) :: :ok
  def async_timeout(time, fun),
    do: GenServer.cast(Timing.Queue, {:timeout, fun, time})

  @doc """
  Set interval concurrently after reference was given back

  Note: This does not stop automagically
  """
  @spec interval(integer(), function()) :: Timing.Queue.task_ref()
  def interval(time, fun),
    do: GenServer.call(Timing.Queue, {:interval, fun, time})

  @doc """
  Set timeout concurrently, after ref was given back
  """
  @spec timeout(function()) :: Timing.Queue.task_ref()
  def timeout(fun),
    do: GenServer.call(Timing.Queue, {:timeout, fun, @second})

  @spec timeout(integer(), function()) :: Timing.Queue.task_ref()
  def timeout(time, fun),
    do: GenServer.call(Timing.Queue, {:timeout, fun, time})

  @doc """
  Clear timeout and interval by their reference
  """
  @spec clear(Timing.Queue.task_ref()) :: :ok
  def clear(ref),
    do: GenServer.cast(Timing.Queue, {:clear, ref})
end
