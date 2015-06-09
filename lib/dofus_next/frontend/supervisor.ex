defmodule DofusNext.Frontend.Supervisor do
  use Supervisor

  alias DofusNext.Frontend.Dofus

  def start_link do
    Supervisor.start_link __MODULE__, []
  end

  def init([]) do
    children = [
      worker(:ranch_sup, []),
      :ranch.child_spec(Dofus, 50, :ranch_tcp, [port: 5555], Dofus, []),
    ]

    supervise children, strategy: :one_for_one
  end
end
