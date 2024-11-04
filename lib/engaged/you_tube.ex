defmodule Engaged.YouTube do
  @moduledoc """
  Manages logic around caption downloads and video lookup.
  """

  alias GoogleApi.YouTube.V3.Connection
  alias GoogleApi.YouTube.V3.Api.Captions

  @default_lang "en"
  @caption_format "srt"

  @doc """
  Retrieves a list of captions for a video given its id.
  """
  def list_captions(video_id) do
    Captions.youtube_captions_list(api_client(), ["id", "snippet"], video_id)
  end

  @doc """
  Retrieves a caption for a video given its id, and language parameter.
  """
  def get_caption(caption_id) do
    Captions.youtube_captions_download(api_client(), caption_id, tfmt: @caption_format)
  end

  defp api_client() do
    api_key = Application.fetch_env!(:engaged, :youtube_api_key)
    Connection.new(api_key)
  end
end
