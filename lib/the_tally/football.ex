defmodule TheTally.Football do
  @moduledoc """
  The Football context.
  """

  import Ecto.Query, warn: false
  import Ecto.Query.API, only: [field: 2]
  alias TheTally.Repo

  alias TheTally.Football.{Player, Rushing}

  @doc """
  Returns the list of players.

  ## Examples

      iex> list_players()
      [%Player{}, ...]

      iex> list_players()
      [%Player{..., rushing: {}}, ...]

      iex> list_players(where: {player: name: "First Last"}})
      [%Player{name: "First Last", ...}, ...]

      iex> list_players(order_by: {rushing: {longest_run: :desc} })
      [%Player{..., rushing: {longest_run: 999}}, %Player{..., rushing: {longest_run: 998}}, ...]
  """
  def list_players(opts \\ []) do
    # TODO: preloads can just be a MapSet
    preloads = Keyword.get(opts, :preloads, [])
    where = Keyword.get(opts, :where, [])
    order_by = Keyword.get(opts, :order_by, [])
    IO.puts("--list_players--")
    IO.inspect(opts)
    IO.puts("--end list players--")

    player_opts = Keyword.get(opts, :player, [])
    base_query()
    |> build_players(player_opts)
    |> join_rushing(Keyword.get(opts, :rushing, []))
    |> sort_players(Keyword.get(player_opts, :order_by, []))
    |> Repo.all()
  end

  def base_query() do
    from(players in Player)
  end

  @doc """
  Builds the query to preload external models.

  ## Examples

    iex> build_players(query, [{ where: {:name, "John Doe"} }])
      [%Player{name: "John Doe", ...}, ...]

  """
  defp build_players(query, opts \\ []) do
    query
    |> filter_players(Keyword.get(opts, :where, []))
  end

  @doc """
  Applies the where filters in `kw_where` on `query`.
  `kw_where` : [ Keyword{column_name, filter_value}]
  """
  defp filter_players(query, kw_where) do
    # IO.puts("filtering players....")
    # IO.inspect(kw_where)
    Enum.reduce(kw_where, query, fn {col, value}, query ->
      query |> where(^[{col, value}])
    end)
  end

  @doc """
  Sorts in Players by `kw_order_by`.
  `kw_order_by` : [ Keyword{column_name, one_of{:asc, :desc}}]
  """
  defp sort_players(query, kw_order_by) do
    Enum.reduce(kw_order_by, query, fn {col, direction}, query ->
      if direction != nil do
        query |> order_by([^direction, ^col])
      end
    end)
  end

  @doc """
  Builds the base Rushing query.
  """
  def base_rushing_query() do
    from(rushing in Rushing)
  end

  @doc """
  """
  defp join_rushing(query, opts \\ []) do
    order_by_list = Keyword.get(opts, :order_by, [])
    # convert the order by from {column: order} to [order, :field, column]
    order_by = Enum.map order_by_list, fn {col, dir} ->
      {dir, :field, col}
    end

    query = from(players in query,
      join: rush in assoc(players, :rushing),
      preload: [rushing: rush]
    )
    Enum.reduce(order_by, query, fn
      {dir, :field, field}, query ->
        from [q,r] in query, order_by: [{^dir, field(r, ^field)}]
    end)

    # from(players in query,
    #   # left_join: rush in Rushing,
    #   # on: rush.player_id == players.id,
    #   join: rush in assoc(players, :rushing),
    #   # order_by: [asc: field(rush, :longest_run)],
    #   # order_by: [{^d, field(rush, ^c)}],
    #   order_by: Enum.reduce(order_by_list, [], fn {dir, col}, acc ->
    #     acc + [{^dir, field(rush, ^col)}]
    #   end),
    #   preload: [rushing: rush]
    # )
    # |> filter_players(Keyword.get(opts, :where, []))
  end

  @doc """
  Gets a single player.

  Raises `Ecto.NoResultsError` if the Player does not exist.

  ## Examples

      iex> get_player!(123)
      %Player{}

      iex> get_player!(456)
      ** (Ecto.NoResultsError)

  """
  def get_player!(id), do: Repo.get!(Player, id)

  @doc """
  Creates a player.

  ## Examples

      iex> create_player(%{field: value})
      {:ok, %Player{}}

      iex> create_player(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_player(attrs \\ %{}) do
    %Player{}
    |> Player.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a player.

  ## Examples

      iex> update_player(player, %{field: new_value})
      {:ok, %Player{}}

      iex> update_player(player, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_player(%Player{} = player, attrs) do
    player
    |> Player.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a player.

  ## Examples

      iex> delete_player(player)
      {:ok, %Player{}}

      iex> delete_player(player)
      {:error, %Ecto.Changeset{}}

  """
  def delete_player(%Player{} = player) do
    Repo.delete(player)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking player changes.

  ## Examples

      iex> change_player(player)
      %Ecto.Changeset{data: %Player{}}

  """
  def change_player(%Player{} = player, attrs \\ %{}) do
    Player.changeset(player, attrs)
  end

  @doc """
  Returns the list of rushings.

  ## Examples

      iex> list_rushings()
      [%Rushing{}, ...]

  """
  def list_rushings do
    Repo.all(Rushing)
  end

  @doc """
  Gets a single rushing.

  Raises `Ecto.NoResultsError` if the Rushing does not exist.

  ## Examples

      iex> get_rushing!(123)
      %Rushing{}

      iex> get_rushing!(456)
      ** (Ecto.NoResultsError)

  """
  def get_rushing!(id), do: Repo.get!(Rushing, id)

  @doc """
  Creates a rushing.

  ## Examples

      iex> create_rushing(%{field: value})
      {:ok, %Rushing{}}

      iex> create_rushing(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_rushing(attrs \\ %{}) do
    %Rushing{}
    |> Rushing.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a rushing.

  ## Examples

      iex> update_rushing(rushing, %{field: new_value})
      {:ok, %Rushing{}}

      iex> update_rushing(rushing, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_rushing(%Rushing{} = rushing, attrs) do
    rushing
    |> Rushing.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a rushing.

  ## Examples

      iex> delete_rushing(rushing)
      {:ok, %Rushing{}}

      iex> delete_rushing(rushing)
      {:error, %Ecto.Changeset{}}

  """
  def delete_rushing(%Rushing{} = rushing) do
    Repo.delete(rushing)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking rushing changes.

  ## Examples

      iex> change_rushing(rushing)
      %Ecto.Changeset{data: %Rushing{}}

  """
  def change_rushing(%Rushing{} = rushing, attrs \\ %{}) do
    Rushing.changeset(rushing, attrs)
  end
end
