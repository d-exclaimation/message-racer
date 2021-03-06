#
#  start_event.ex
#  server
#
#  Created by d-exclaimation on 11:38.
#

defmodule MessageRacerWeb.Event.Start do
  @moduledoc """
  Start Event struct
  """
  @enforce_keys [:type, :payload, :id]
  defstruct [:type, :payload, :id]

  @typedoc """
  StartEvent Struct Type
  """
  @type t() :: %__MODULE__{}
end
