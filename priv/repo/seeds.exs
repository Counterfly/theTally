# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     TheTally.Repo.insert!(%TheTally.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

defmodule TheTally.DatabaseSeeder do
  alias TheTally.Repo
  alias TheTally.Football.Player
  alias TheTally.Football.Rushing

  @spec seed(charlist()) :: nil
  def seed(json_file) do
    # read json_file
    with {:ok, body} <- File.read(json_file),
         {:ok, json} <- Jason.decode(body, keys: :atoms) do
      # save seed data to database
      # `json` will be a list of JSON objects

      json
      |> Enum.map(&insert_player/1)
      |> Enum.map(&insert_rushing/1)
    else
      err ->
        IO.inspect(err)
    end
  end

  @doc """
  Inserts a new player into the database.

  Returns `{player_data, %Player{}}`

  ## Examples

      iex> insert_player(player_data)
      %Player{}

  """
  @spec insert_player(map()) :: {map(), %Player{id: pos_integer()}}
  def insert_player(json_seed_data) when is_map(json_seed_data) do
    player =
      Repo.insert!(%Player{
        name: Map.get(json_seed_data, :Player, nil),
        position: Map.get(json_seed_data, :Pos, nil),
        team: Map.get(json_seed_data, :Team, nil)
      })

    # so we can easily chain functions we return a
    # tuple of the original data and the newly inserted data
    {json_seed_data, player}
  end

  @spec insert_rushing({map(), %Player{id: pos_integer()}}) ::
          {map(), %Player{id: pos_integer()}, %Rushing{id: pos_integer()}}
  def insert_rushing({json_seed_data, player}) when is_map(json_seed_data) do
    # Below we use the following conversions:
    ## value / 1 to auto-convert any integers to float
    ## to_string to convert anything to string (ex. longest_run includes data like '75T')
    ## Integer.parse to convert a string-like representation to an integer
    {attempts, _} = to_integer(Map.get(json_seed_data, :Att, nil))
    {first_downs, _} = to_integer(Map.get(json_seed_data, :"1st", nil))
    {fumbles, _} = to_integer(Map.get(json_seed_data, :FUM, nil))
    {min_forty_yards, _} = to_integer(Map.get(json_seed_data, :"20+", nil))
    {min_twenty_yards, _} = to_integer(Map.get(json_seed_data, :"40+", nil))
    {yards, _} = to_integer(Map.get(json_seed_data, :Yds, nil))

    rushing =
      Repo.insert!(%Rushing{
        attempts: attempts,
        attempts_per_game: Map.get(json_seed_data, :"Att/G", nil) / 1,
        first_down_percentage: Map.get(json_seed_data, :"1st%", nil) / 1,
        first_downs: first_downs,
        fumbles: fumbles,
        longest_run: to_string(Map.get(json_seed_data, :Lng, nil)),
        min_forty_yards: min_forty_yards,
        min_twenty_yards: min_twenty_yards,
        touchdowns: Map.get(json_seed_data, :TD, nil),
        yards: yards,
        yards_per_carry: Map.get(json_seed_data, :Avg, nil) / 1,
        yards_per_game: Map.get(json_seed_data, :"Yds/G", nil) / 1,
        player_id: player.id
      })

    # so we can easily chain functions we return a
    # tuple of the original data and the newly inserted data
    {json_seed_data, player, rushing}
  end

  defp to_integer(any) do
    :string.to_integer(Kernel.to_charlist(any))
  end
end

json_file = "#{__DIR__}/../../rushing-parsed.json"

TheTally.DatabaseSeeder.seed(json_file)
