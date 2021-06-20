#
#  user_resolver.ex
#  server
#
#  Created by d-exclaimation on 20:28.
#

defmodule MessageRacerWeb.UserResolver do
  @moduledoc """
  User Resolvers
  """
  use Absinthe.Schema.Notation
  alias MessageRacerWeb.Schema

  @desc "User resolvers"
  object :user_resolver do
    @desc "State my name"
    field :state_name, :string do
      arg(:name, non_null(:string))
      resolve(&state_name/2)
    end
  end

  @doc """
  State your name
  """
  @spec state_name(%{name: String.t()}, Absinthe.Resolution.t()) :: Schema.returned(String.t())
  def state_name(%{name: name}, %Absinthe.Resolution{context: %{} = ctx}) do
    {:ok, "Hello #{name} #{inspect(ctx)}"}
  end
end
