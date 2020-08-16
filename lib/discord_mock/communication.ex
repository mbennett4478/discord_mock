defmodule DiscordMock.Communication do
  @moduledoc """
  The Communication context.
  """

  import Ecto.Query, warn: false
  alias DiscordMock.Repo

  alias DiscordMock.Communication.{Room, UserRoom}

  @doc """
  Returns the list of rooms.

  ## Examples

      iex> list_rooms()
      [%Room{}, ...]

  """
  def list_rooms(user) do
    Ecto.assoc(user, :rooms)
    |> Repo.all
    |> Repo.preload(:users)
  end

  @doc """
  Gets a single room.

  Raises `Ecto.NoResultsError` if the Room does not exist.

  ## Examples

      iex> get_room!(123)
      %Room{}

      iex> get_room!(456)
      ** (Ecto.NoResultsError)

  """
  def get_room!(id), do: Repo.get!(Room, id)

  @doc """
  Creates a room.

  ## Examples

      iex> create_room(%{field: value})
      {:ok, %Room{}}

      iex> create_room(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_room(user_ids, attrs \\ %{}) do
    changeset = Room.changeset(%Room{}, attrs)

    case Repo.insert(changeset) do
      {:ok, room} ->
        users = Enum.map(user_ids, fn user_id ->
          UserRoom.changeset(%UserRoom{}, %{user_id: user_id, room_id: room.id})
        end)
        results = users
          |> Enum.with_index
          |> Enum.reduce(Ecto.Multi.new(), fn ({changeset, index}, multi) ->
            Ecto.Multi.insert(multi, Integer.to_string(index), changeset)
          end)
          |> Repo.transaction

        case results do
          {:ok, _multi_user_rooms} ->
            room = Repo.preload(room, :users)
            {:ok, room}
          {:error, _, changeset, _} -> {:error, changeset}
        end
      {:error, changeset} -> {:error, changeset}
    end
  end

  def add_user_to_room(user_id, room_id) do
    room = get_room!(room_id)
    changeset = UserRoom.changeset(%UserRoom{}, %{user_id: user_id, room_id: room.id})

    case Repo.insert(changeset) do
      {:ok, _user_room} ->
        {:ok, Repo.preload(room, :users)}
      {:error, changeset} -> {:error, changeset}
    end
  end

  @doc """
  Updates a room.

  ## Examples

      iex> update_room(room, %{field: new_value})
      {:ok, %Room{}}

      iex> update_room(room, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_room(%Room{} = room, attrs) do
    room
    |> Room.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Room.

  ## Examples

      iex> delete_room(room)
      {:ok, %Room{}}

      iex> delete_room(room)
      {:error, %Ecto.Changeset{}}

  """
  def delete_room(%Room{} = room) do
    Repo.delete(room)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking room changes.

  ## Examples

      iex> change_room(room)
      %Ecto.Changeset{source: %Room{}}

  """
  def change_room(%Room{} = room) do
    Room.changeset(room, %{})
  end
end
