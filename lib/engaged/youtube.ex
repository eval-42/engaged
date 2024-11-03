defmodule Engaged.Youtube do
  @moduledoc """
  Manages logic around caption downloads and video lookup.
  """

  alias GoogleApi.Gax.Connection
  alias GoogleApi.YouTube.V3.Api.Captions

  @language "en"

  @doc """
  Retrieves a caption for a video given its id.
  """
  def caption_for_video(video_id) do
    Tesla.get!("https://google.ca")
    {:ok, "caption"}
  end
end
