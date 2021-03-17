defmodule TheTally.Repo do
  use Ecto.Repo,
    otp_app: :the_tally,
    adapter: Ecto.Adapters.Postgres
end
