defmodule MessageRacer.Repo.Migrations.UpdateRaceRoomsTable do
  use Ecto.Migration

  def change do
    alter table(:race_rooms) do
      add :winner, :string, null: true
    end
  end
end
