defmodule DofusNext.Frontend do
  alias DofusNext.Frontend.Supervisor

  def start_link do
    Supervisor.start_link
  end
end
