defmodule Engaged.Clients.YouTubeClient do
  @moduledoc """
  Contains shared initialization of youtube clients for calling the API.
  """
  alias GoogleApi.YouTube.V3.Connection

  def new() do
    api_key = Application.fetch_env!(:engaged, :youtube_api_key)
    Connection.new(api_key)
  end
end
