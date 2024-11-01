defmodule Engaged.Repo do
  use Ecto.Repo,
    otp_app: :engaged,
    adapter: Ecto.Adapters.Postgres
end
