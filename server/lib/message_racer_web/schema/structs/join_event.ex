#
#  join_event.ex
#  server
#
#  Created by d-exclaimation on 11:42.
#

defmodule MessageRacerWeb.Event.Join do
  @moduledoc """
  Join Event
  """
  @enforce_keys [:type, :username]
  defstruct [:type, :username]

  @typedoc """
  JoinEvent Struct Type
  """
  @type t() :: %__MODULE__{}
end
