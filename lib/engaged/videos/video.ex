defmodule Engaged.Videos.Video do
  use Ecto.Schema
  import Ecto.Changeset

  schema "videos" do
    field :source_type, Ecto.Enum, values: [:youtube], default: :youtube
    field :external_id, :string

    has_many :captions, Engaged.Captions.Caption

    timestamps(type: :utc_datetime)
  end

  def changeset(caption, params \\ %{}) do
    caption
    |> cast(params, [:source_type, :external_id])
    |> validate_required([:source_type, :external_id])
  end
end
