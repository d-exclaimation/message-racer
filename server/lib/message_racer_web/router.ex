defmodule MessageRacerWeb.Router do
  use MessageRacerWeb, :router
  alias Absinthe.Blueprint

  pipeline :api do
    plug :accepts, ["json"]
    plug MessageRacerWeb.Plug.Auth
  end

  scope "/" do
    pipe_through :api

    forward "/graphql", Absinthe.Plug,
      schema: MessageRacerWeb.Schema,
      before_send: {__MODULE__, :session_auth}
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: MessageRacerWeb.Telemetry
    end
  end

  @spec session_auth(Plug.Conn.t(), Absinthe.Blueprint.t()) :: Plug.Conn.t()
  def session_auth(
        conn,
        %Blueprint{execution: %Blueprint.Execution{context: %{session_id: id}}}
      ) do
    conn
    |> fetch_session()
    |> put_session(:user_id, id)
  end

  def session_auth(conn, _blueprint), do: conn
end
