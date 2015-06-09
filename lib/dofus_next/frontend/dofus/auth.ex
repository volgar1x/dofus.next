defmodule DofusNext.Frontend.Dofus.Auth do
  use Bitwise
  require Logger
  alias DofusNext.Frontend.Session
  alias DofusNext.Frontend.Dofus.Realm
  alias DofusNext.Frontend.Dofus.Nicknaming

  def handle(sess, data) do
    [user, pass] = String.split(data, "\n#1", parts: 2)
    pass = decrypt(pass, Session.get_attr(sess, :id))
    Logger.debug "user: #{user} pass: #{pass}"
    handle(sess, user, pass)
  end

  defp handle(sess, "test", "test") do
    sess |> Session.put_attr(:state, Nicknaming)
         |> Session.send("AlEr")
  end

  defp handle(sess, _user, _pass) do
    Session.send_close(sess, "AlEf")
  end

  @alphabet "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_"
  @alphabet_len String.length(@alphabet)

  defp from_alphabet(_, <<>>, _), do: :not_found
  defp from_alphabet(c, << c :: utf8, _rest :: binary >>, i), do: i
  defp from_alphabet(c, << _other :: utf8, rest :: binary >>, i), do: from_alphabet(c, rest, i + 1)
  defp from_alphabet(c), do: from_alphabet(c, @alphabet, 0)

  def decrypt(<<>>, _key), do: <<>>

  def decrypt(
      << a :: utf8, b :: utf8, rest :: binary >>,
      << pkey :: utf8, key :: binary >>) do
    ## doesnt work well with other than ?a..?z

    apass = case (from_alphabet(a) - pkey + @alphabet_len) do
      i when i < 0 -> (i + 64)
      i -> i
    end <<< 4

    akey = case (from_alphabet(b) - pkey + @alphabet_len) do
      i when i < 0 -> (i + 64)
      i -> i
    end

    ppass = apass + akey

    tail = decrypt(rest, key)
    << ppass :: utf8, tail :: binary >>
  end
end
