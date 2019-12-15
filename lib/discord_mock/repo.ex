defmodule DiscordMock.Repo do
  use Ecto.Repo,
    otp_app: :discord_mock,
    adapter: Ecto.Adapters.Postgres
end
