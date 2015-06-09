defmodule DofusNext.Frontend.Dofus.Version do
  require Logger
  alias DofusNext.Frontend.Session
  alias DofusNext.Frontend.Dofus.Auth

  def handle(sess, "1.29.1") do
    Session.put_attr(sess, :state, Auth)
  end

  def handle(sess, invalid) do
    Logger.warn "a client tried to connect with an invalid version #{invalid}"
    Session.close(sess)
  end
end
