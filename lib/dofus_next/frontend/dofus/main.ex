defmodule DofusNext.Frontend.Dofus.Main do
  alias DofusNext.Frontend.Session
  alias DofusNext.Frontend.Dofus.Version

  def connect(sess) do
    id = rand_id()
    sess |> Session.put_attr(:id, id)
         |> Session.send("HC#{id}")
  end

  def handle(sess, data) do
    case sess.attrs[:state] do
      nil -> Version.handle(sess, data)
      state -> state.handle(sess, data)
    end
  end

  def rand_id(n \\ 32, acc \\ "")

  def rand_id(0, acc) do
    acc
  end

  def rand_id(n, acc) do
    ch = ?a + :random.uniform(25)
    rand_id(n-1, <<ch, acc :: binary>>)
  end
end
