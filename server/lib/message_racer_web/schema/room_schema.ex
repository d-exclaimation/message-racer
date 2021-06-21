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
    field :id, non_null(:id)

    field :players, non_null(list_of(non_null(:player))) do
      resolve(dataloader(PlayerLoader, :players, []))
    end
  end
end
