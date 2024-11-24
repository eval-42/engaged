defmodule Engaged.YouTube do
  @moduledoc """
  Manages logic around caption downloads and video lookup.
  """

  alias Engaged.Clients.YouTubeClient

  alias GoogleApi.YouTube.V3.Api, as: API

  @default_lang "en"
  @caption_format "srt"

  @doc """
  Retrieves a list of playlist items given a playlist id.
  """
  def list_playlist_items(playlist_id) do
    result =
      YouTubeClient.new()
      |> API.PlaylistItems.youtube_playlist_items_list(["snippet"],
        playlistId: playlist_id
      )

    normalize_result(result, & &1.items)
  end

  @doc """
  Retrieves a list of playlist items given a playlist id and page_token.
  """
  def list_playlist_items(playlist_items, page_token \\ nil)

  def list_playlist_items(playlist_id, page_token) when is_nil(page_token) do
    list_playlist_items(playlist_id)
  end

  def list_playlist_items(playlist_id, page_token) when is_binary(page_token) do
    result =
      YouTubeClient.new()
      |> API.PlaylistItems.youtube_playlist_items_list(["snippet"],
        playlistId: playlist_id,
        pageToken: page_token
      )

    normalize_result(result, & &1.items)
  end

  @doc """
  Retrieves a list of captions for a video given its id.
  """
  def list_captions(video_id) do
    result =
      YouTubeClient.new()
      |> API.Captions.youtube_captions_list(["id", "snippet"], video_id)

    normalize_result(result, & &1.items)
  end

  @doc """
  Retrieves a caption for a video given its id, and language parameter.
  """
  def download_caption(caption_id) do
    result =
      YouTubeClient.new()
      |> API.Captions.youtube_captions_download(caption_id, tfmt: @caption_format)

    normalize_result(result, &decode_binary(&1.body))
  end

  defp normalize_result(result, success) do
    case result do
      {:error, %Tesla.Env{status: 403}} ->
        {:error, :unauthorized}

      {:error, _other} = other_error ->
        other_error

      {:ok, value} ->
        {:ok, success.(value)}
    end
  end

  def decode_binary(binary) do
    case binary do
      <<0xFE, 0xFF, rest::binary>> ->
        :unicode.characters_to_binary(rest, {:utf16, :big}, :utf8)

      <<0xFF, 0xFE, rest::binary>> ->
        :unicode.characters_to_binary(rest, {:utf16, :little}, :utf8)

      <<0xEF, 0xBB, 0xBF, rest::binary>> ->
        # UTF-8 with BOM
        rest

      _ ->
        # Assume UTF-8 without BOM
        binary
    end
  end
end
