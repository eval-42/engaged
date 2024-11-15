defmodule Engaged.YouTubeTest do
  use ExUnit.Case, async: true

  import Mox
  import Tesla.Test

  alias Engaged.Fixtures

  setup :set_mox_from_context
  setup :verify_on_exit!

  describe "list_playlist_items/1" do
    test "successfully decodes playlist items" do
      expect_tesla_call(
        times: 1,
        returns: %Tesla.Env{
          status: 200,
          body: Fixtures.load_fixture("youtube/playlist_items.json")
        }
      )

      assert {:ok, results} = Engaged.YouTube.list_playlist_items("test_playlist")

      assert_received_tesla_call(env)
      assert env.url =~ "/youtube/v3/playlistItems"

      [first, second] = Enum.map(results, & &1.snippet)

      assert first.title =~ "Getting Started with Web Development"
      assert second.title =~ "Advanced CSS Techniques"
    end
  end

  describe "list_playlist_items/2" do
    test "successfully decodes playlist items with page token" do
      expect_tesla_call(
        times: 1,
        returns: %Tesla.Env{
          status: 200,
          body: Fixtures.load_fixture("youtube/playlist_items.json")
        }
      )

      assert {:ok, results} = Engaged.YouTube.list_playlist_items("test_playlist", "some_token")

      assert_received_tesla_call(env)
      assert env.url =~ "/youtube/v3/playlistItems"

      [first, second] = Enum.map(results, & &1.snippet)

      assert first.title =~ "Getting Started with Web Development"
      assert second.title =~ "Advanced CSS Techniques"
    end

    test "handles unauthorized error" do
      expect_tesla_call(times: 1, returns: quota_exceeded_env())

      assert {:error, :unauthorized} =
               Engaged.YouTube.list_playlist_items("test_playlist", "page_token")
    end

    test "handles other errors" do
      expect_tesla_call(times: 1, returns: %Tesla.Env{status: 500})

      assert {:error, %Tesla.Env{status: 500}} =
               Engaged.YouTube.list_playlist_items("test_playlist", "page_token")
    end
  end

  describe "list_captions/1" do
    test "successfully retrieves captions list" do
      expect_tesla_call(
        times: 1,
        returns: %Tesla.Env{status: 200, body: Fixtures.load_fixture("youtube/captions.json")}
      )

      assert {:ok, results} = Engaged.YouTube.list_captions("test_video")

      assert_received_tesla_call(env)
      assert env.url =~ "/youtube/v3/captions"

      [first, second] = Enum.map(results, & &1.snippet)

      assert "en" == first.language
      assert "es" == second.language
    end

    test "handles unauthorized error" do
      expect_tesla_call(times: 1, returns: quota_exceeded_env())

      assert {:error, :unauthorized} = Engaged.YouTube.list_captions("test_video")
    end
  end

  describe "download_caption/1" do
    test "successfully downloads caption" do
      expect_tesla_call(
        times: 1,
        returns: %Tesla.Env{
          status: 200,
          headers: [{"Content-Type", "application/octet-stream"}],
          body: Fixtures.load_fixture("youtube/caption.srt", binary: true)
        }
      )

      assert {:ok, result} = Engaged.YouTube.download_caption("test_caption")

      assert_received_tesla_call(env)
      assert env.url =~ "/youtube/v3/captions"

      assert result =~ "This is a test caption"
    end

    test "handles unauthorized error" do
      expect_tesla_call(times: 1, returns: quota_exceeded_env())

      assert {:error, :unauthorized} = Engaged.YouTube.download_caption("caption_id")
    end
  end

  defp quota_exceeded_env() do
    quota_exceeded = Fixtures.load_fixture("youtube/quota_exceeded.json")

    %Tesla.Env{
      status: 403,
      body: quota_exceeded
    }
  end
end
