defmodule Engaged.Captions.Caption do
  use Ecto.Schema
  import Ecto.Changeset

  schema "captions" do
    field :language, :string
    field :content, :string

    belongs_to :video, Engaged.Videos.Video

    timestamps(type: :utc_datetime)
  end

  def changeset(caption, params \\ %{}) do
    caption
    |> cast(params, [:language, :content])
    |> validate_required([:language, :content])
  end
end
