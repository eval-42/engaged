defmodule Engaged.YoutubeTest do
  use ExUnit.Case, async: true

  require Tesla.Test

  setup context, do: Mox.set_mox_from_context(context)
  setup context, do: Mox.verify_on_exit!(context)

  alias Engaged.Youtube

  describe "caption_for_video/1" do
    test "returns a caption" do
      Tesla.Test.expect_tesla_call(
        times: 1,
        returns: Tesla.Test.json(%Tesla.Env{status: 200}, %{id: 1})
      )

      Youtube.caption_for_video(nil)

      Tesla.Test.assert_received_tesla_call(%Tesla.Env{})
    end
  end
end
