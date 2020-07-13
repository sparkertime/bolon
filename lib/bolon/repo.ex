defmodule Bolon.Repo do
  use Ecto.Repo,
    otp_app: :bolon,
    adapter: Ecto.Adapters.Postgres
end
