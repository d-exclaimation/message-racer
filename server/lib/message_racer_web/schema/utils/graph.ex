#
#  tool.ex
#  server
#
#  Created by d-exclaimation on 13:44.
#

defmodule MessageRacerWeb.Graph do
  @moduledoc """
  Schema tools
  """
  alias Absinthe.Subscription

  @typedoc """
  Absinthe GraphQL Returned types of valid or error
  """
  @type returned(t) :: {:ok, t} | {:error, String.t()}

  @typedoc """
  Subscription compound key of (field <> topic_id)
  """
  @type subscription_keys :: [{atom, term | (term -> term)}]

  @typedoc """
  Data payload
  """
  @type payload :: struct() | map()

  @endpoint MessageRacerWeb.Endpoint

  @doc """
  Ok tuple with payload
  """
  @spec ok(a) :: {:ok, a} when a: var
  def ok(payload), do: {:ok, payload}

  @doc """
  Error tuple with args
  """
  @spec error(String.t()) :: {:error, String.t()}
  def error(args), do: {:error, args}

  @doc """
  Ok tuple with fallback in case for nil
  """
  @spec ok_else(a, (a -> String.t())) :: {:ok, a} | {:error, String.t()} when a: var
  def ok_else(nil, fallback), do: {:error, fallback.(nil)}
  def ok_else(payload, _fallback), do: {:ok, payload}

  @doc """
  Ok tuple with payload and auth for middleware
  """
  @spec ok_auth(a, b) :: {:ok, %{value: a, auth: b}} when a: var, b: var
  def ok_auth(payload, auth), do: {:ok, %{value: payload, auth: auth}}

  @doc """
  Dispatch a payload to subscription(s)
  """
  @spec dispatch(payload(), subscription_keys() | Absinthe.Resolution.t()) :: :ok
  def dispatch(payload, opts), do: Subscription.publish(@endpoint, payload, opts)
end
