defmodule MessageRacer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Timing function seperate thread task capabilities
      {Timing.Supervisor, name: Timing.Supervisor},
      # Game InMemory
      {MessageRacer.InMemory.Supervisor, name: MessageRacer.InMemory.Supervisor},
      # Start the Ecto repository
      MessageRacer.Repo,
      # Start the Telemetry supervisor
      MessageRacerWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: MessageRacer.PubSub},
      # Start the Endpoint (http/https)
      MessageRacerWeb.Endpoint,
      {Absinthe.Subscription, MessageRacerWeb.Endpoint}
      # Start a worker by calling: MessageRacer.Worker.start_link(arg)
      # {MessageRacer.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MessageRacer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    MessageRacerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
