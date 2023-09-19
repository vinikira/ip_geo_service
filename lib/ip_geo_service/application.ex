defmodule IpGeoService.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      IpGeoServiceWeb.Telemetry,
      # Start the Ecto repository
      IpGeoService.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: IpGeoService.PubSub},
      # Start Finch
      {Finch, name: IpGeoService.Finch},
      # Start the Endpoint (http/https)
      IpGeoServiceWeb.Endpoint
      # Start a worker by calling: IpGeoService.Worker.start_link(arg)
      # {IpGeoService.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: IpGeoService.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    IpGeoServiceWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
