defmodule Coffee.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      CoffeeWeb.Telemetry,
      Coffee.Repo,
      {DNSCluster,
       query: Application.get_env(:coffee, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Coffee.PubSub},
      # Send emails
      {Finch, name: Coffee.Finch},
      CoffeeWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Coffee.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CoffeeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
