defmodule TheTally.Repo.Migrations.CreatePlayers do
  use Ecto.Migration

  def change do
    create table(:players) do
      add :name, :string
      add :team, :string, size: 10
      add :position, :string, size: 40

      timestamps()
    end
  end
end
