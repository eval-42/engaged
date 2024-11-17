defmodule Engaged.Workers.SubscriptionsWorker do
  @moduledoc """
  Iterates subscriptions system-wide and adds jobs to the correct queue for processing if they are not up to date.
  """
  use Oban.Worker, queue: :monitors

  alias Engaged.Subscriptions
  alias Engaged.Subscriptions.Subscription, as: Sub

  alias Engaged.Workers

  @impl true
  def perform(_job) do
    Subscriptions.list_subscriptions()
    |> Enum.map(&subscription_to_job/1)
    |> Enum.reject(&(&1 == :drop))
    |> Oban.insert_all()

    :ok
  end

  defp subscription_to_job(subscription) do
    with worker when is_atom(worker) <- select_worker(subscription),
         job_type when is_binary(job_type) <- job_type(subscription),
         job_args when is_map(job_args) <- subscription_to_args(job_type, subscription) do
      worker.new(job_args)
    else
      _ -> :drop
    end
  end

  defp subscription_to_args(job_type, %Sub{} = subscription) do
    case job_type do
      "pull_playlist" -> %{type: job_type, playlist_id: subscription.external_id}
      "pull_channel" -> %{type: job_type, channel_id: subscription.external_id}
      _ -> :drop
    end
  end

  defp job_type(subscription) do
    case subscription do
      %Sub{source_type: :playlist} -> "pull_playlist"
      %Sub{source_type: :channel} -> "pull_channel"
      _ -> :drop
    end
  end

  defp select_worker(subscription) do
    case subscription do
      %Sub{source: :youtube} -> Workers.YouTubeAPIWorker
      _ -> nil
    end
  end
end
