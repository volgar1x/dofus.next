defmodule DofusNext.User do
  @hash :sha256

  @moduledoc """
  Represent a User
  """

  defstruct name: "",
            pass: "",
            hash: "",
            nick: "",
            question: ""

  @doc "Randomly create a alphabetical string"
  def rand_hash(n \\ 32, acc \\ "")

  def rand_hash(0, acc) do
    acc
  end

  def rand_hash(n, acc) do
    ch = ?a + :random.uniform(25)
    rand_hash(n-1, <<ch, acc :: binary>>)
  end

  @doc "Hash a string using cryptographical methods"
  def hexhash(bin) do
    :crypto.hash(@hash, bin)
    |> Hexate.encode
  end

  # Concat two binaries
  defp concat(a, b) do
    a <> b
  end

  @doc "Encode a password using a seed"
  def encode_one_pass(pass, hash) do
    pass
    |> hexhash
    |> concat(hash)
    |> hexhash
  end

  @doc "Check a user's password"
  def is_valid_pass?(user, pass) do
    user.pass == encode_one_pass(pass, user.hash)
  end

  @doc "Encode user's password and return an updated struct"
  def encode_pass(user) do
    hash = rand_hash(128)
    pass = encode_one_pass(user.pass, hash)
    %__MODULE__{user | hash: hash, pass: pass}
  end
end
