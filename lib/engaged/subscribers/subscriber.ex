defmodule Engaged.Subscribers.Subscriber do
  @moduledoc """
  An end user that is subscribed to summarized updates.
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "subscribers" do
    field :email, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(subscriber, attrs) do
    subscriber
    |> cast(attrs, [:email])
    |> validate_required([:email])
    |> unique_constraint(:email)
  end
end
