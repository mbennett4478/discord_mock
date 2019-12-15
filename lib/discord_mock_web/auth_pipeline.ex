defmodule DiscordMock.Guardian.AuthPipeline do
  use Guardian.Plug.Pipeline, otp_app: :discord_mock,
    module: DiscordMock.Guardian,
    error_handler: DiscordMock.AuthErrorHandler

  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
