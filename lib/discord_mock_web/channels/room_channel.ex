defmodule DiscordMockWeb.RoomChannel do
  use DiscordMockWeb, :channel
  alias DiscordMock.Communication

  def join("room:" <> room_id, _params, socket) do
    room = Communication.get_room!(room_id)

    response = %{
      room: Phoenix.View.render_one(room, DiscordMockWeb.RoomView, "room.json"),
    }

    {:ok, response, assign(socket, :room, room)}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (room:lobby).
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end

  def terminate(_reason, socket) do
    {:ok, socket}
  end
end
