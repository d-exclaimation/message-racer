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
  alias MessageRacerWeb.Endpoint

  @type returned(t) :: {:ok, t} | {:error, String.t()}
  @type subscription_key :: {atom, term | (term -> term)}

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
  Dispatch to a subscription endpoint
  """
  @spec dispatch(struct() | map(), subscription_key() | Absinthe.Resolution.t()) :: :ok
  def dispatch(payload, opts), do: Subscription.publish(Endpoint, payload, opts)
end
