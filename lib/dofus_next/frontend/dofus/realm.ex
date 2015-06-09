defmodule DofusNext.Frontend.Dofus.Realm do
  alias DofusNext.Frontend.Session

  def handle(sess, "Af") do
    Session.send(sess, "Af0|0||0")
  end
end
