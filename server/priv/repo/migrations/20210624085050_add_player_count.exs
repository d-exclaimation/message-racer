defmodule MessageRacer.Repo.Migrations.AddPlayerCount do
  use Ecto.Migration

  def change do
    alter table(:race_rooms) do
      add :player_count, :integer, default: 0
    end
  end
end
