defmodule Engaged.Summaries.CaptionSummary do
  @moduledoc """
  Represents a summarized video caption.
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "caption_summaries" do
    belongs_to :caption, Engaged.Captions.Caption
    field :content, :string
  end

  def changeset(summary, attrs) do
    summary
    |> cast(attrs, [:content])
    |> validate_required([:content])
  end
end
