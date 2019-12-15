defmodule DiscordMockWeb.Router do
  use DiscordMockWeb, :router

  alias DiscordMock.Guardian

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :jwt_authenticated do
    plug Guardian.AuthPipeline
  end

  scope "/api/v1", DiscordMockWeb do
    pipe_through :api

    post "/sign-up", UserController, :create
    post "/sign-in", UserController, :sign_in
  end

  scope "/api/v1", DiscordMockWeb do
    pipe_through [:api, :jwt_authenticated]

    get "/my-user", UserController, :show
  end
end
