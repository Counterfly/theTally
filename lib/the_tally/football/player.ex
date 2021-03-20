defmodule TheTally.Football.Player do
  use Ecto.Schema
  import Ecto.Changeset
  alias TheTally.Football.Rushing

  schema "players" do
    field :name, :string
    field :position, :string
    field :team, :string

    # has many rushings, in case the player changes team
    ## or we later want to do per-season
    has_one :rushing, Rushing, foreign_key: :player_id

    timestamps()
  end

  @doc false
  def changeset(player, attrs) do
    player
    |> cast(attrs, [:name, :team, :position, :dateStarted])
    |> validate_required([:name, :team, :position, :dateStarted])
  end
end
