defmodule MessageRacer.Race.Player do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "race_players" do
    field :username, :string
    belongs_to :race_room, MessageRacer.Race.Room, foreign_key: :room_id

    timestamps()
  end

  @typedoc """
  Player Struct Type
  """
  @type t() :: %__MODULE__{}

  @doc false
  def changeset(player, attrs) do
    player
    |> cast(attrs, [:username])
    |> validate_required([:username])
    |> unique_constraint(:username)
  end
end
