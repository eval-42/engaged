defmodule Engaged.Workers.APIMonitorWorker do
  @moduledoc """
  Watches for paused queues and resumes them on a predefined schedule.
  """
  use Oban.Worker, queue: :monitors, unique: true

  @impl true
  def perform(%{args: %{queue: queue}}) do
    Oban.resume_queue(queue)
  end
end
