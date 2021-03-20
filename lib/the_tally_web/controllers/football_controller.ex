defmodule TheTallyWeb.FootballController2 do

  use TheTallyWeb, :controller

  alias TheTally.Football
  alias TheTally.Football.Player
  alias TheTally.Football.Rushing

  def index(conn, _params) do
    players = Player.list_players()
    render(conn, "index.html", players: players)
  end
end
