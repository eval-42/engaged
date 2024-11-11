defmodule Engaged.Repo.Migrations.CreateCaptionSummaries do
  use Ecto.Migration

  def change do
    create table(:caption_summaries) do
      add :caption_id, references(:captions), null: false
      add :content, :text, null: false
    end

    create unique_index(:caption_summaries, :caption_id)
  end
end
