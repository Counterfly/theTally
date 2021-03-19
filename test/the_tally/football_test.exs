defmodule TheTally.FootballTest do
  use TheTally.DataCase

  alias TheTally.Football

  describe "players" do
    alias TheTally.Football.Player

    @valid_attrs %{
      dateStarted: ~D[2010-04-17],
      name: "some name",
      position: "some position",
      team: "some team"
    }
    @update_attrs %{
      dateStarted: ~D[2011-05-18],
      name: "some updated name",
      position: "some updated position",
      team: "some updated team"
    }
    @invalid_attrs %{dateStarted: nil, name: nil, position: nil, team: nil}

    def player_fixture(attrs \\ %{}) do
      {:ok, player} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Football.create_player()

      player
    end

    test "list_players/0 returns all players" do
      player = player_fixture()
      assert Football.list_players() == [player]
    end

    test "get_player!/1 returns the player with given id" do
      player = player_fixture()
      assert Football.get_player!(player.id) == player
    end

    test "create_player/1 with valid data creates a player" do
      assert {:ok, %Player{} = player} = Football.create_player(@valid_attrs)
      assert player.dateStarted == ~D[2010-04-17]
      assert player.name == "some name"
      assert player.position == "some position"
      assert player.team == "some team"
    end

    test "create_player/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Football.create_player(@invalid_attrs)
    end

    test "update_player/2 with valid data updates the player" do
      player = player_fixture()
      assert {:ok, %Player{} = player} = Football.update_player(player, @update_attrs)
      assert player.dateStarted == ~D[2011-05-18]
      assert player.name == "some updated name"
      assert player.position == "some updated position"
      assert player.team == "some updated team"
    end

    test "update_player/2 with invalid data returns error changeset" do
      player = player_fixture()
      assert {:error, %Ecto.Changeset{}} = Football.update_player(player, @invalid_attrs)
      assert player == Football.get_player!(player.id)
    end

    test "delete_player/1 deletes the player" do
      player = player_fixture()
      assert {:ok, %Player{}} = Football.delete_player(player)
      assert_raise Ecto.NoResultsError, fn -> Football.get_player!(player.id) end
    end

    test "change_player/1 returns a player changeset" do
      player = player_fixture()
      assert %Ecto.Changeset{} = Football.change_player(player)
    end
  end

  describe "rushings" do
    alias TheTally.Football.Rushing

    @valid_attrs %{
      attempts: 42,
      attempts_per_game: 120.5,
      first_down_percentage: 120.5,
      first_downs: 42,
      fumbles: 42,
      longest_run: "some longest_run",
      min_forty_yards: 42,
      min_twenty_yards: 42,
      player_id: 42,
      touchdowns: 42,
      yards: 42,
      yards_per_carry: 120.5,
      yards_per_game: 120.5
    }
    @update_attrs %{
      attempts: 43,
      attempts_per_game: 456.7,
      first_down_percentage: 456.7,
      first_downs: 43,
      fumbles: 43,
      longest_run: "some updated longest_run",
      min_forty_yards: 43,
      min_twenty_yards: 43,
      player_id: 43,
      touchdowns: 43,
      yards: 43,
      yards_per_carry: 456.7,
      yards_per_game: 456.7
    }
    @invalid_attrs %{
      attempts: nil,
      attempts_per_game: nil,
      first_down_percentage: nil,
      first_downs: nil,
      fumbles: nil,
      longest_run: nil,
      min_forty_yards: nil,
      min_twenty_yards: nil,
      player_id: nil,
      touchdowns: nil,
      yards: nil,
      yards_per_carry: nil,
      yards_per_game: nil
    }

    def rushing_fixture(attrs \\ %{}) do
      {:ok, rushing} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Football.create_rushing()

      rushing
    end

    test "list_rushings/0 returns all rushings" do
      rushing = rushing_fixture()
      assert Football.list_rushings() == [rushing]
    end

    test "get_rushing!/1 returns the rushing with given id" do
      rushing = rushing_fixture()
      assert Football.get_rushing!(rushing.id) == rushing
    end

    test "create_rushing/1 with valid data creates a rushing" do
      assert {:ok, %Rushing{} = rushing} = Football.create_rushing(@valid_attrs)
      assert rushing.attempts == 42
      assert rushing.attempts_per_game == 120.5
      assert rushing.first_down_percentage == 120.5
      assert rushing.first_downs == 42
      assert rushing.fumbles == 42
      assert rushing.longest_run == "some longest_run"
      assert rushing.min_forty_yards == 42
      assert rushing.min_twenty_yards == 42
      assert rushing.player_id == 42
      assert rushing.touchdowns == 42
      assert rushing.yards == 42
      assert rushing.yards_per_carry == 120.5
      assert rushing.yards_per_game == 120.5
    end

    test "create_rushing/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Football.create_rushing(@invalid_attrs)
    end

    test "update_rushing/2 with valid data updates the rushing" do
      rushing = rushing_fixture()
      assert {:ok, %Rushing{} = rushing} = Football.update_rushing(rushing, @update_attrs)
      assert rushing.attempts == 43
      assert rushing.attempts_per_game == 456.7
      assert rushing.first_down_percentage == 456.7
      assert rushing.first_downs == 43
      assert rushing.fumbles == 43
      assert rushing.longest_run == "some updated longest_run"
      assert rushing.min_forty_yards == 43
      assert rushing.min_twenty_yards == 43
      assert rushing.player_id == 43
      assert rushing.touchdowns == 43
      assert rushing.yards == 43
      assert rushing.yards_per_carry == 456.7
      assert rushing.yards_per_game == 456.7
    end

    test "update_rushing/2 with invalid data returns error changeset" do
      rushing = rushing_fixture()
      assert {:error, %Ecto.Changeset{}} = Football.update_rushing(rushing, @invalid_attrs)
      assert rushing == Football.get_rushing!(rushing.id)
    end

    test "delete_rushing/1 deletes the rushing" do
      rushing = rushing_fixture()
      assert {:ok, %Rushing{}} = Football.delete_rushing(rushing)
      assert_raise Ecto.NoResultsError, fn -> Football.get_rushing!(rushing.id) end
    end

    test "change_rushing/1 returns a rushing changeset" do
      rushing = rushing_fixture()
      assert %Ecto.Changeset{} = Football.change_rushing(rushing)
    end
  end
end
