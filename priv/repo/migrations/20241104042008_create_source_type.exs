defmodule Engaged.Repo.Migrations.CreateSourceType do
  use Ecto.Migration

  @create_type "CREATE TYPE video_source AS ENUM ('youtube')"
  @drop_type "DROP TYPE video_source"

  def change do
    execute(@create_type, @drop_type)
  end
end
