defmodule DofusNext.UserTest do
  use ExUnit.Case

  alias DofusNext.User

  test "password encoding" do
    assert User.encode_password("test", "test") == "d36ed169b0452636221ec97da8202bdb5831a10d21e5e25aee66fc92a0625f46"
  end

  # test "user creation" do
  #   params = %{"name" => "test", "pass" => "test", "nick" => "test", "question" => "test"}
  #   user = User.create(params)

  #   assert user.name == "test"
  #   assert user.pass == User.encode_password("test", user.hash)
  #   assert user.nick == "test"
  #   assert user.question == "test"
  # end
end
