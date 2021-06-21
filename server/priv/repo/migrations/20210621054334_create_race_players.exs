defmodule MessageRacer.Repo.Migrations.CreateRacePlayers do
  use Ecto.Migration

  def change do
    create table(:race_players, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :username, :string
      add :room_id, references(:race_rooms, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    create unique_index(:race_players, [:username])
    create index(:race_players, [:room_id])
  end
end
