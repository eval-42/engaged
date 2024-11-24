defmodule Engaged.Workers.SubscriptionsWorkerTest do
  use Engaged.DataCase, async: true

  alias Engaged.Workers.SubscriptionsWorker
  alias Engaged.Workers.YouTubeAPIWorker

  describe "perform/1" do
    test "successfully enqueues jobs for valid youtube playlist subscriptions" do
      subs = insert_list(2, :subscription, source_type: :playlist)

      assert :ok = perform_job(SubscriptionsWorker, %{})

      Enum.each(subs, fn sub ->
        assert_enqueued(
          worker: YouTubeAPIWorker,
          args: %{"playlist_id" => sub.external_id}
        )
      end)
    end

    test "successfully enqueues jobs for valid youtube channel subscriptions" do
      subs = insert_list(2, :subscription, source_type: :channel)

      assert :ok = perform_job(SubscriptionsWorker, %{})

      Enum.each(subs, fn sub ->
        assert_enqueued(
          worker: YouTubeAPIWorker,
          args: %{"channel_id" => sub.external_id}
        )
      end)
    end

    test "successfully enqueues jobs for mixed youtube subscriptions" do
      first = insert(:subscription, source_type: :playlist)
      second = insert(:subscription, source_type: :channel)

      assert :ok = perform_job(SubscriptionsWorker, %{})

      assert_enqueued(worker: YouTubeAPIWorker, args: %{"playlist_id" => first.external_id})
      assert_enqueued(worker: YouTubeAPIWorker, args: %{"channel_id" => second.external_id})
    end

    test "handles empty subscription list" do
      refute_enqueued(worker: YouTubeAPIWorker)
    end
  end
end
