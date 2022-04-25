defmodule Life.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  alias Life.Server

  @name GameStarter

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Life.Repo,
      # Start the Telemetry supervisor
      LifeWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Life.PubSub},
      # Start the Endpoint (http/https)
      LifeWeb.Endpoint,
      # Supervisor for game instances
      {DynamicSupervisor, strategy: :one_for_one, name: @name}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Life.Supervisor]

    Supervisor.start_link(children, opts)
  end

  def start_game() do
    DynamicSupervisor.start_child(@name, {Server, nil})
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LifeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
