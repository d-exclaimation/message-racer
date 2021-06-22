#
#  player_schema.ex
#  server
#
#  Created by d-exclaimation on 13:36.
#

defmodule MessageRacerWeb.PlayerSchema do
  @moduledoc """
  Player Schema Object
  """
  use Absinthe.Schema.Notation
  alias MessageRacer.RoomLoader
  import Absinthe.Resolution.Helpers, only: [dataloader: 3]

  @desc "Player Object"
  object :player do
    @desc "The id, duh"
    field :id, non_null(:id)
    @desc "Unique username"
    field :username, non_null(:string)
    @desc "Room id player belongs to"
    field :room_id, non_null(:id)

    @desc "Room player belong to"
    field :room, non_null(:room) do
      resolve(dataloader(RoomLoader, :room, []))
    end
  end

  @desc "Player info needed to join a room"
  input_object :join_input do
    @desc "Unique username"
    field :username, non_null(:string)
  end
end
