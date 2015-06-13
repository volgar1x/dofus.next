defmodule DofusNext.Frontend.Dofus.Auth do
  use Bitwise
  require Logger
  alias DofusNext.Repo
  alias DofusNext.User
  alias DofusNext.Frontend.Session
  alias DofusNext.Frontend.Dofus.Realm

  def handle(sess, data) do
    [name, pass] = String.split(data, "\n#1", parts: 2)
    pass = decrypt(pass, Session.get_attr(sess, :id))
    Logger.debug "user: #{name} pass: #{pass}"
    handle(sess, name, pass)
  end

  defp handle(sess, name, pass) do
    case Repo.get_by(User, name: name) do
      nil ->
        Session.send_close(sess, "AlEf")

      user ->
        if User.is_valid_pass?(user, pass) do
          sess
          |> Session.put_attr(user: user, state: Realm)
          |> Session.send(~w(Ad#{user.nick}
                             Ac0
                             AH1;1;75;1
                             AlK0
                             AQ#{user.question}))
        else
          Session.send_close(sess, "AlEf")
        end
    end
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
