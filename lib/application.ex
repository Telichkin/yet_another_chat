defmodule YetAnotherChat.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(YetAnotherChat.Repo, []),
      supervisor(YetAnotherChat.Endpoint, []),
      worker(YetAnotherChat.MessageStorage, []),
      worker(YetAnotherChat.UsersCounter, []),
    ]

    opts = [strategy: :one_for_one, name: YetAnotherChat.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    YetAnotherChat.Endpoint.config_change(changed, removed)
    :ok
  end
end
