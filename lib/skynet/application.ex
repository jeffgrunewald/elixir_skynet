defmodule Skynet.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Skynet.Server,
      {DynamicSupervisor, strategy: :one_for_one, name: Skynet.CyberDynamicSupervisor},
      SkynetWeb.Endpoint
    ]

    opts = [strategy: :rest_for_one, name: Skynet.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    SkynetWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
