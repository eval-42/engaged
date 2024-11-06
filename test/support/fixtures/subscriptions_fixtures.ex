defmodule Engaged.SubscriptionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Engaged.Subscriptions` context.
  """

  @doc """
  Generate a subscription.
  """
  def subscription_fixture(attrs \\ %{}) do
    {:ok, subscription} =
      attrs
      |> Enum.into(%{

      })
      |> Engaged.Subscriptions.create_subscription()

    subscription
  end
end
