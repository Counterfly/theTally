defmodule TheTally.Repo.Migrations.CreateRushings do
  use Ecto.Migration

  def change do
    create table(:rushings) do
      add :player_id, references(:players, on_delete: :delete_all), null: false
      add :attempts, :integer
      add :attempts_per_game, :float
      add :yards, :integer
      add :yards_per_carry, :float
      add :yards_per_game, :float
      add :touchdowns, :integer
      add :longest_run, :string
      add :first_downs, :integer
      add :first_down_percentage, :float
      add :min_twenty_yards, :integer
      add :min_forty_yards, :integer
      add :fumbles, :integer

      timestamps()
    end

    # TODO: create index(:rushings, [:tbd])
  end
end
