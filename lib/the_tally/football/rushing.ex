defmodule TheTally.Football.Rushing do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rushings" do
    field :attempts, :integer
    field :attempts_per_game, :float
    field :first_down_percentage, :float
    field :first_downs, :integer
    field :fumbles, :integer
    field :longest_run, :string
    field :min_forty_yards, :integer
    field :min_twenty_yards, :integer
    field :player_id, :id
    field :touchdowns, :integer
    field :yards, :integer
    field :yards_per_carry, :float
    field :yards_per_game, :float

    timestamps()
  end

  @doc false
  def changeset(rushing, attrs) do
    rushing
    |> cast(attrs, [
      :player_id,
      :attempts,
      :attempts_per_game,
      :yards,
      :yards_per_carry,
      :yards_per_game,
      :touchdowns,
      :longest_run,
      :first_downs,
      :first_down_percentage,
      :min_twenty_yards,
      :min_forty_yards,
      :fumbles
    ])
    |> validate_required([
      :player_id,
      :attempts,
      :attempts_per_game,
      :yards,
      :yards_per_carry,
      :yards_per_game,
      :touchdowns,
      :longest_run,
      :first_downs,
      :first_down_percentage,
      :min_twenty_yards,
      :min_forty_yards,
      :fumbles
    ])
  end
end
