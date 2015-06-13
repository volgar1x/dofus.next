defmodule DofusNext.User do
  use Ecto.Model
  alias DofusNext.Repo

  schema "users" do
    field :name
    field :pass
    field :hash
    field :nick
    field :question
    field :inserted_at, :datetime
    field :updated_at, :datetime
  end

  def is_valid_pass?(user, pass) do
    true
  end
end
