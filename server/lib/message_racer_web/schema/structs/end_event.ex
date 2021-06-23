#
#  end_event.ex
#  server
#
#  Created by d-exclaimation on 11:41.
#

defmodule MessageRacerWeb.Event.End do
  @moduledoc """
  End Game Event
  """
  @enforce_keys [:type]
  defstruct [:type]

  @typedoc """
  EndEvent Struct Type
  """
  @type t() :: %__MODULE__{}
end
