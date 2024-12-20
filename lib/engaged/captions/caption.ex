defmodule Engaged.Captions.Caption do
  @moduledoc """
  A caption for a video in SRT format.
  """

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
    |> cast(params, [:video_id, :language, :content])
    |> validate_required([:video_id, :language, :content])
  end
end
