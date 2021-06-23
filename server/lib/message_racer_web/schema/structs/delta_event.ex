#
#  delta_event.ex
#  server
#
#  Created by d-exclaimation on 11:39.
#

defmodule MessageRacerWeb.Event.Delta do
  @moduledoc """
  Delta Event struct
  """
  @enforce_keys [:type, :index, :word, :username]
  defstruct [:type, :index, :word, :username]

  @typedoc """
  DeltaEvent Struct Type
  """
  @type t() :: %__MODULE__{}
end
