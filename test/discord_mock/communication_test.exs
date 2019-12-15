defmodule DiscordMock.CommunicationTest do
  use DiscordMock.DataCase

  alias DiscordMock.Communication

  describe "rooms" do
    alias DiscordMock.Communication.Room

    @valid_attrs %{name: "some name", topic: "some topic"}
    @update_attrs %{name: "some updated name", topic: "some updated topic"}
    @invalid_attrs %{name: nil, topic: nil}

    def room_fixture(attrs \\ %{}) do
      {:ok, room} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Communication.create_room()

      room
    end

    test "list_rooms/0 returns all rooms" do
      room = room_fixture()
      assert Communication.list_rooms() == [room]
    end

    test "get_room!/1 returns the room with given id" do
      room = room_fixture()
      assert Communication.get_room!(room.id) == room
    end

    test "create_room/1 with valid data creates a room" do
      assert {:ok, %Room{} = room} = Communication.create_room(@valid_attrs)
      assert room.name == "some name"
      assert room.topic == "some topic"
    end

    test "create_room/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Communication.create_room(@invalid_attrs)
    end

    test "update_room/2 with valid data updates the room" do
      room = room_fixture()
      assert {:ok, %Room{} = room} = Communication.update_room(room, @update_attrs)
      assert room.name == "some updated name"
      assert room.topic == "some updated topic"
    end

    test "update_room/2 with invalid data returns error changeset" do
      room = room_fixture()
      assert {:error, %Ecto.Changeset{}} = Communication.update_room(room, @invalid_attrs)
      assert room == Communication.get_room!(room.id)
    end

    test "delete_room/1 deletes the room" do
      room = room_fixture()
      assert {:ok, %Room{}} = Communication.delete_room(room)
      assert_raise Ecto.NoResultsError, fn -> Communication.get_room!(room.id) end
    end

    test "change_room/1 returns a room changeset" do
      room = room_fixture()
      assert %Ecto.Changeset{} = Communication.change_room(room)
    end
  end
end
