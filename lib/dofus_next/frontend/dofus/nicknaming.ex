defmodule DofusNext.Frontend.Dofus.Nicknaming do
  alias DofusNext.Frontend.Session
  alias DofusNext.Frontend.Dofus.Realm

  def handle(sess, "Af") do
    Realm.handle(sess, "Af")
  end

  def handle(sess, nickname) do
    sess |> Session.put_attr(state: Realm, nickname: nickname)
         |> Session.send("AlK")
  end
end
