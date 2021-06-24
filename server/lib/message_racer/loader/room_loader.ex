#
#  room_loader.ex
#  server
#
#  Created by d-exclaimation on 14:27.
#

defmodule MessageRacer.RoomLoader do
  @moduledoc """
  Dataloader source for Rooms
  """
  alias MessageRacer.Race.{Player, Room}
  alias MessageRacer.RoomQueries

  @doc """
  Provide a loader for room
  """
  @spec data() :: %Dataloader.KV{}
  def data() do
    Dataloader.KV.new(&fetch/2)
  end

  @doc """
  Fetch correct room
  """
  @spec fetch({atom(), map()}, [map() | Player.t()]) :: %{Player.t() => Room.t()}
  def fetch({:room, %{}}, [%{}]) do
    %{
      %{} => nil
    }
  end

  def fetch({:room, %{}}, args) do
    all_rooms =
      args
      |> Enum.filter(fn
        %Player{} -> true
        _ -> false
      end)
      |> Enum.map(fn
        %Player{room_id: rid} -> rid
      end)
      |> RoomQueries.all_within()

    args
    |> Enum.reduce(%{}, fn
      %Player{room_id: id} = arg, prev ->
        prev
        |> Map.put(arg, Enum.find(all_rooms, fn %Room{id: rid} -> rid == id end))

      arg, prev ->
        prev
        |> Map.put(arg, nil)
    end)
  end

  def fetch(_, args), do: args |> Enum.reduce(%{}, fn x, acc -> acc |> Map.put(x, nil) end)
end
