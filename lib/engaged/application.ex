defmodule Engaged.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      EngagedWeb.Telemetry,
      Engaged.Repo,
      {DNSCluster, query: Application.get_env(:engaged, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Engaged.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Engaged.Finch},
      # Start a worker by calling: Engaged.Worker.start_link(arg)
      # {Engaged.Worker, arg},
      # Start to serve requests, typically the last entry
      EngagedWeb.Endpoint,
      {Task.Supervisor, name: Engaged.TaskSupervisor},
      {Oban, Application.fetch_env!(:engaged, Oban)}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Engaged.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    EngagedWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
