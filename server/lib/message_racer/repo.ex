defmodule MessageRacer.Repo do
  use Ecto.Repo,
    otp_app: :message_racer,
    adapter: Ecto.Adapters.Postgres
end
