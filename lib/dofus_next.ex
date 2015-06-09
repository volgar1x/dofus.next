defmodule DofusNext do
  use Application
  require Logger

  def start(_type, _args) do
    Logger.debug "DofusNext will now start"
    DofusNext.Supervisor.start_link
  end
end
