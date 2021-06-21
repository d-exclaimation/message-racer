defmodule MessageRacer.Repo.Migrations.CreateRaceRooms do
  use Ecto.Migration

  def change do
    create table(:race_rooms, primary_key: false) do
      add :id, :binary_id, primary_key: true

      timestamps()
    end

  end
end
