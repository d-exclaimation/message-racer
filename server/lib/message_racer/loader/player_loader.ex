#
#  player_loader.ex
#  server
#
#  Created by d-exclaimation on 16:19.
#

defmodule MessageRacer.PlayerLoader do
  @moduledoc """
  Dataloader source for Player query
  """
  alias MessageRacer.Race.{Player, Room}
  alias MessageRacer.PlayerQueries

  @doc """
  Get data source
  """
  @spec data() :: %Dataloader.KV{}
  def data() do
    Dataloader.KV.new(&fetch/2)
  end

  @doc """
  Fetch batch of data
  """
  @spec fetch({atom(), map()}, [map() | Room.t()]) :: %{Room.t() => [Player.t()]}
  def fetch({:players, %{}}, [%{}]) do
    %{
      %{} => PlayerQueries.all([])
    }
  end

  def fetch({:players, %{}}, args) do
    all_players =
      args
      |> Enum.map(fn %Room{id: id} -> id end)
      |> PlayerQueries.all()

    args
    |> Enum.reduce(%{}, fn
      %Room{id: room_id} = arg, prev ->
        prev
        |> Map.put(
          arg,
          all_players
          |> Enum.filter(fn x ->
            x.room_id == room_id
          end)
        )

      arg, prev ->
        prev |> Map.put(arg, [])
    end)
  end

  def fetch(batch, args) do
    IO.inspect(batch)
    args |> Enum.reduce(%{}, fn arg, accum -> Map.put(accum, arg, []) end)
  end
end
