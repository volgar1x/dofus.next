defmodule DofusNext.Frontend.Dofus.Main do
  alias DofusNext.Frontend.Session
  alias DofusNext.Frontend.Dofus.Version
  alias DofusNext.User

  def connect(sess) do
    id = User.rand_hash
    sess
    |> Session.put_attr(id: id)
    |> Session.send("HC#{id}")
  end

  def handle(sess, data) do
    case sess.attrs[:state] do
      nil -> Version.handle(sess, data)
      state -> state.handle(sess, data)
    end
  end
end
