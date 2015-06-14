defmodule DofusNext.Frontend.Supervisor do
  use Supervisor

  alias DofusNext.Frontend.Dofus
  alias DofusNext.Frontend.HTTP

  def start_link do
    Supervisor.start_link __MODULE__, []
  end

  def init([]) do
    children = [
      :ranch.child_spec(Dofus, 50, :ranch_tcp, [port: 5555], Dofus, []),
      Plug.Adapters.Cowboy.child_spec(:http, HTTP, [], port: 5557),
    ]

    supervise children, strategy: :one_for_one
  end
end
