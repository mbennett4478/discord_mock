defmodule DiscordMockWeb.RoomView do
  use DiscordMockWeb, :view
  alias DiscordMockWeb.{RoomView, UserView}

  def render("index.json", %{rooms: rooms}) do
    %{data: render_many(rooms, RoomView, "room.json")}
  end

  def render("show.json", %{room: room}) do
    %{data: render_one(room, RoomView, "room.json")}
  end

  def render("room.json", %{room: room}) do
    %{id: room.id,
      name: room.name,
      topic: room.topic,
      users: render_many(room.users, UserView, "user.json")}
  end
end
