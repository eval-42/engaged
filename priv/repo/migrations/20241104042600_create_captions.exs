defmodule Engaged.Repo.Migrations.CreateCaptions do
  use Ecto.Migration

  def change do
    create table(:captions) do
      add :video_id, references(:videos), null: false
      add :language, :string, null: false
      add :content, :text, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:captions, [:video_id, :language])
  end
end
