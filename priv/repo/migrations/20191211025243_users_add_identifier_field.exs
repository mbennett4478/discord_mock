defmodule DiscordMock.Repo.Migrations.UsersAddIdentifierField do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :identifier, :string
    end

    create unique_index(:users, [:username, :identifier], name: :index_users_on_username_and_identifier)
  end
end
