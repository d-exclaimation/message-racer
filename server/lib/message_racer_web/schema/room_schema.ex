#
#  room_schema.ex
#  server
#
#  Created by d-exclaimation on 12:25.
#

defmodule MessageRacerWeb.RoomSchema do
  @moduledoc """
  Room Schema
  """
  alias MessageRacer.PlayerLoader
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 3]

  import_types(MessageRacerWeb.PlayerSchema)

  @desc "Room Object type"
  object :room do
    @desc "Identifier"
    field :id, non_null(:id)

    @desc "Players joined in this room"
    field :players, non_null(list_of(non_null(:player))) do
      resolve(dataloader(PlayerLoader, :players, []))
    end
  end

  input_object :delta_input do
    field :room_id, non_null(:id)
    field :username, non_null(:string)
    field :changes, non_null(:changes)
  end

  input_object :changes do
    field :index, non_null(:integer)
    field :word, non_null(:string)
  end
end
