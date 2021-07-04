#
#  graphql_socket.ex
#  server
#
#  Created by d-exclaimation on 19:51.
#

defmodule MessageRacerWeb.GraphqlSocket do
  @moduledoc """
  """
  use SubscriptionsTransportWS.Socket,
    schema: MessageRacerWeb.Schema,
    keep_alive: 3_600_000

  @doc """
  Callback to connect through the websocket
  """
  @impl true
  @spec connect(any(), Socket.t()) :: {:ok, Socket.t()}
  def connect(_param, socket) do
    {:ok, socket}
  end

  @doc """
  Initialize the connection
  """
  @impl true
  @spec gql_connection_init(any(), Socket.t()) :: {:ok, Socket.t()}
  def gql_connection_init(_msg, socket) do
    {:ok, socket}
  end
end
