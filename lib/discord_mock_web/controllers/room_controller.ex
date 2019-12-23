defmodule DiscordMockWeb.RoomController do
  use DiscordMockWeb, :controller

  alias DiscordMock.Communication
  alias DiscordMock.Communication.Room

  # action_fallback DiscordMockWeb.FallbackController

  def index(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)
    rooms = Communication.list_rooms(current_user)
    render(conn, "index.json", rooms: rooms)
  end

  def create(conn, %{"room" => room_params, "users" => user_ids}) do
    current_user = Guardian.Plug.current_resource(conn)
    user_ids = [current_user.id | user_ids]
    with {:ok, %Room{} = room} <- Communication.create_room(user_ids, room_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.room_path(conn, :show, room))
      |> render("show.json", room: room)
    end
  end

  def join(conn, %{"id" => room_id}) do
    current_user = Guardian.Plug.current_resource(conn)
    
    with {:ok, %Room{} = room} <- Communication.add(current_user.id, room_id) do
      render(conn, "show.json", room: room)
    end
  end

  ##### Implement these later #####
  def show(conn, %{"id" => id}) do
    room = Communication.get_room!(id)
    render(conn, "show.json", room: room)
  end

  def update(conn, %{"id" => id, "room" => room_params}) do
    room = Communication.get_room!(id)

    with {:ok, %Room{} = room} <- Communication.update_room(room, room_params) do
      render(conn, "show.json", room: room)
    end
  end

  def delete(conn, %{"id" => id}) do
    room = Communication.get_room!(id)

    with {:ok, %Room{}} <- Communication.delete_room(room) do
      send_resp(conn, :no_content, "")
    end
  end
end
