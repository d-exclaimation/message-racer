defmodule MessageRacer.Race.Room do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "race_rooms" do
    field :winner, :string
    field :player_count, :integer
    has_many :race_players, MessageRacer.Race.Player
    timestamps()
  end

  @typedoc """
  Room Struct Type
  """
  @type t() :: %__MODULE__{}

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [])
    |> validate_required([])
  end
end
