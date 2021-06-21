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

  @desc "Player Object"
  object :player do
    field :id, non_null(:id)
    field :username, non_null(:string)
    field :room_id, non_null(:id)
  end

  input_object :join_input do
    field :username, non_null(:string)
  end
end
