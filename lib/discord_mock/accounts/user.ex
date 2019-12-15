defmodule DiscordMock.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias DiscordMock.Accounts.User

  # import Comeonin.Bcrypt, only: [hash_pwd_salt: 1]

  schema "users" do
    field :email, :string
    field :password_hash, :string
    field :username, :string
    field :identifier, :string
    many_to_many :rooms, DiscordMock.Communication.Room, join_through: "user_rooms"
    # Virtual Fields
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:identifier, :username, :email, :password, :password_confirmation])
    |> validate_required([:identifier, :username, :email, :password, :password_confirmation])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 8)
    |> validate_confirmation(:password)
    |> unique_constraint(:email)
    |> unique_constraint(:username, name: :index_users_on_username_and_identifier)
    |> put_password_hash
  end

  def put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}}
        -> put_change(changeset, :password_hash, Bcrypt.hash_pwd_salt(pass))
      _ -> changeset
    end
  end
end
