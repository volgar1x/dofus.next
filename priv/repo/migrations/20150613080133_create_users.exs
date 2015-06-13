defmodule DofusNext.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def up do
    create table(:users) do
      add :name, :string, size: 50
      add :pass, :string, size: 50
      add :hash, :string, size: 128
      add :nick, :string, size: 50
      add :question, :string, size: 50
      timestamps
    end
  end

  def down do
    drop table(:users)
  end
end
