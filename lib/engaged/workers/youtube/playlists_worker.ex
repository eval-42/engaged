defmodule Engaged.Workers.YouTube.PlaylistsWorker do
  @moduledoc """
  Watches for new playlist items, and enqueues jobs to download captions.
  """
  use Oban.Worker, queue: :youtube

  @impl true
  def perform(%{args: %{queue: queue}}) do
    Oban.resume_queue(queue)
  end
end
