defmodule Engaged.Workers.YouTube.CaptionsWorker do
  @moduledoc """
  Watches for new enqueued videos and downloads captions for them.
  """
  use Oban.Worker, queue: :youtube

  @impl true
  def perform(%{args: %{queue: queue}}) do
    {:snooze, 60}
  end
end
