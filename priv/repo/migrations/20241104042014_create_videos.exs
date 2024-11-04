defmodule Engaged.Repo.Migrations.CreateVideos do
  use Ecto.Migration

  def change do
    create table(:videos) do
      add :source_type, :video_source, null: false
      add :external_id, :string, null: false
    end

    create unique_index(:videos, [:source_type, :external_id])
  end
end
