#
#  auth.ex
#  server
#
#  Created by d-exclaimation on 15:54.
#

defmodule MessageRacerWeb.Plug.Auth do
  @moduledoc """
  Plug for authentication
  """
  @behaviour Plug

  import Plug.Conn
  alias MessageRacer.PlayerQueries

  @doc """
  Create the plug
  """
  @spec init(any) :: atom | binary | [atom] | [any] | tuple | number | map | MapSet.t()
  def init(opts), do: opts

  @doc """
  Validation of user session (Auth), error will send a 401 (previously a redirect)
  """
  @spec call(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def call(conn, _) do
    res =
      conn
      |> fetch_session()
      |> get_session(:user_id)

    case res do
      nil ->
        conn

      user_id ->
        ctx = %{user: PlayerQueries.get_by_id(user_id)}

        conn
        |> Absinthe.Plug.put_options(context: ctx)
    end
  end
end
