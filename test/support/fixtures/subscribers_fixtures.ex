defmodule Engaged.SubscribersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Engaged.Subscribers` context.
  """

  @doc """
  Generate a unique subscriber email.
  """
  def unique_subscriber_email, do: "some email#{System.unique_integer([:positive])}"

  @doc """
  Generate a subscriber.
  """
  def subscriber_fixture(attrs \\ %{}) do
    {:ok, subscriber} =
      attrs
      |> Enum.into(%{
        email: unique_subscriber_email()
      })
      |> Engaged.Subscribers.create_subscriber()

    subscriber
  end
end
