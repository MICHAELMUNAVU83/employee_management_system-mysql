defmodule EmployeeManagementSystem.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      EmployeeManagementSystem.Repo,
      # Start the Telemetry supervisor
      EmployeeManagementSystemWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: EmployeeManagementSystem.PubSub},
      # Start the Endpoint (http/https)
      EmployeeManagementSystemWeb.Endpoint
      # Start a worker by calling: EmployeeManagementSystem.Worker.start_link(arg)
      # {EmployeeManagementSystem.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: EmployeeManagementSystem.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    EmployeeManagementSystemWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
