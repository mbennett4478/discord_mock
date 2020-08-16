defmodule DiscordMockWeb.UserView do
  use DiscordMockWeb, :view
  alias DiscordMockWeb.UserView

  def render("index.json", %{users: users}) do
    render_many(users, UserView, "user.json")
  end

  def render("show.json", %{user: user}) do
    render_one(user, UserView, "user.json")
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      identifier: user.identifier,
      username: user.username,
      email: user.email}
  end

  def render("jwt.json", %{jwt: jwt}) do
    %{access_token: jwt}
  end
end
