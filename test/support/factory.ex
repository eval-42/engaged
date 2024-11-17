defmodule Engaged.Factory do
  @moduledoc """
  Factories for generating schema fixtures in tests.
  """

  use ExMachina.Ecto, repo: Engaged.Repo

  alias Engaged.Subscriptions.Subscription

  def subscription_factory do
    %Subscription{
      source_type: Enum.random([:playlist, :channel]),
      source: :youtube,
      external_id: "subscription_#{System.unique_integer()}"
    }
  end
end
