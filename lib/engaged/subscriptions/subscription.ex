defmodule Engaged.Subscriptions.Subscription do
  use Ecto.Schema
  import Ecto.Changeset

  schema "subscriptions" do
    field :source, Ecto.Enum, values: [:youtube]
    field :source_type, Ecto.Enum, values: [:channel, :playlist]

    field :external_id, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(subscription, attrs) do
    subscription
    |> cast(attrs, [:source, :source_type, :external_id])
    |> validate_required([:source, :source_type, :external_id])
  end
end
