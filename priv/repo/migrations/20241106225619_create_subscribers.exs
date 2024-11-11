defmodule Engaged.Repo.Migrations.CreateSubscribers do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    create table(:subscribers) do
      add :email, :citext

      timestamps(type: :utc_datetime)
    end

    create unique_index(:subscribers, [:email])
  end
end
