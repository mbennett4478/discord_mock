defmodule DiscordMock.Repo.Migrations.RoomsAddTypeField do
  use Ecto.Migration

  def change do
    alter table(:rooms) do
      add :is_server, :boolean, default: false
    end
  end
end
