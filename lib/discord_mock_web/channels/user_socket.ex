defmodule DiscordMockWeb.UserSocket do
  use Phoenix.Socket

  channel "room:*", DiscordMockWeb.RoomChannel

  def connect(%{"token" => token}, socket) do
    # Decode and verify token
    case Guardian.decode_and_verify(token) do
      {:ok, claims} ->
        # Get user from claims
        case Guardian.resource_from_claims(claims) do
          {:ok, user} ->
            {:ok, assign(socket, :current_user, user)}
          {:error, _reason} ->
            :error
        end
      {:error, _reason} -> 
        :error
    end
  end

  def connect(_params, _socket), do: :error

  def id(socket), do: "users_socket:#{socket.assigns.current_user.id}"
end
