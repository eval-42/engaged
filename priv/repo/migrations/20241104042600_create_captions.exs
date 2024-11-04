defmodule Engaged.Repo.Migrations.CreateCaptions do
  use Ecto.Migration

  def change do
    create table(:captions, primary_key: false) do
      add :video_id, references(:videos), null: false, primary_key: true
      add :language, :string, null: false
      add :content, :text, null: false
    end

    create unique_index(:captions, [:video_id, :language])
  end
end
