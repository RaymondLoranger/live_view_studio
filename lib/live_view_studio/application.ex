defmodule LiveView.Studio.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      LiveView.StudioWeb.Telemetry,
      LiveView.Studio.Repo,
      {DNSCluster,
       query:
         Application.get_env(:live_view_studio, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: LiveView.Studio.PubSub},
      # Start a worker by calling: LiveView.Studio.Worker.start_link(arg)
      # {LiveView.Studio.Worker, arg},
      # Start to serve requests, typically the last entry
      LiveView.StudioWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LiveView.Studio.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LiveView.StudioWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
