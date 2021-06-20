#
#  schema.ex
#  server
#
#  Created by d-exclaimation on 19:54.
#

defmodule MessageRacerWeb.Schema do
  @moduledoc """
  Root Schema
  """
  use Absinthe.Schema

  import_types(MessageRacerWeb.UserResolver)
  @type returned(t) :: {:ok, t} | {:error, String.t()}

  query do
    @desc "Hello field"
    field :hello, :string do
      resolve(fn _args, _resolution ->
        {:ok, "Hello World"}
      end)
    end

    import_fields(:user_resolver)
  end
end
