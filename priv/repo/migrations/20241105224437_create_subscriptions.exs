defmodule Engaged.Repo.Migrations.CreateSubscriptions do
  use Ecto.Migration

  @create_type "CREATE TYPE sub_source_type AS ENUM ('channel', 'playlist')"
  @drop_type "DROP TYPE sub_source_type"

  def change do
    execute(@create_type, @drop_type)

    create table(:subscriptions) do
      add :source, :video_source, null: false
      add :source_type, :sub_source_type, null: false

      add :external_id, :string, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:subscriptions, [:source, :source_type, :external_id])
  end
end
