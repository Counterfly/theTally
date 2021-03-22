defmodule TheTallyWeb.FootballLive do
  use TheTallyWeb, :live_view

  alias TheTally.Football

  @impl true
  def mount(_params, _session, socket) do
    # no need for periodic updates since data is rarely updated
    # if connected?(socket), do: Process.send_after(self(), :update, 30000)

    players = Football.list_players()

    query = [
      {:player, []},
      {:rushing, []}
    ]

    {:ok, assign(socket, player: players, query: query)}
    # case Football.list_players() do
    #   [players] ->
    #     {:ok, assign(socket, player: players)}

    #   nil ->
    #     # error, redirect to error page
    #     {:ok, redirect(socket, to: "/error")}
    # end
  end

  def handle_info(:update, socket) do
    # nothing to do?
    Process.send_after(self(), :update, 30000)
    {:noreply, socket}
  end

  def handle_event("toggleLng", _, socket) do
    handle_toggle(socket, :longest_run)
  end

  def handle_event("toggleTd", _, socket) do
    handle_toggle(socket, :touchdowns)
  end

  def handle_event("toggleYds", _, socket) do
    handle_toggle(socket, :yards)
  end

  @doc """
  Handles all (Rushing) toggle-ables.

  ## Examples
    iex> handle_toggle(socket, :yards)
      %Socket{}
  """
  defp handle_toggle(socket, atom) do
    query = socket.assigns.query
    rush_query = Keyword.get(query, :rushing, [])
    rush_query_order_by = Keyword.get(rush_query, :order_by, [])
    value = Keyword.get(rush_query_order_by, atom, nil)

    # since there are 3 states (no sorting, ascending, descending)
    value = transition_order_by(value)

    rush_query_order_by = Keyword.put(rush_query_order_by, atom, value)
    rush_query = Keyword.put(rush_query, :order_by, rush_query_order_by)
    query = Keyword.put(query, :rushing, rush_query)
    update_players(query, socket)
  end

  @doc """
  Returns a css class string for a column depending on if it's being sorted.
  """
  def sort_column_class(sort_value) do
    if sort_value != nil do
      "bg-blue-300 highlight-2 highlight-blue" # tailwind classes
    else
      ""
    end
  end

  @doc """
  Returns the next transition state for sortng given the current `order_by`.

  Transition: nil (no order) -> ASC -> DESC -> nil
  """
  defp transition_order_by(ordering) when is_atom(ordering) do
    case ordering do
      :asc -> :desc
      :desc -> nil
      _ -> :asc
    end
  end

  @doc """
  Returns the placeholder for the 'Search by Player Name' input field.
  """
  def placeholder_search_by_player(nil) do
    "Player Name" # this is a placeholder for the player name search
  end

  def placeholder_search_by_player(search_player_name) do
    search_player_name
  end

  def handle_event("search_player", %{"name" => name}, socket) do
    # submit a new query for player name search
    update_query_with_new_player_name(socket.assigns.query, name)
    |> update_players(socket)
  end

  @doc """
  Keydown was paused because it needs to be more robust.
  Known failing:
    CMD+a Backspace (select-all backspace) deletes everything but this only deletes the last character
  """
  # def handle_event("search_player_keydown", %{"key" => "Enter"}, socket) do
  #   # submit a new query
  #   IO.puts("Keydown Enter, starting search")
  #   update_players(socket.assigns.query, socket)
  # end

  # def handle_event("search_player_keydown", %{"key" => "Backspace"}, socket) do
  #   # update socket state
  #   query = socket.assigns.query
  #   player_query = Keyword.get(query, :player, [])
  #   player_query_where = Keyword.get(player_query, :where, [])
  #   current_name = Keyword.get(player_query_where, :name, "")

  #   if String.length(current_name) == 0 do
  #     # do nothing
  #     {:noreply, socket}
  #   else
  #     # update the socket's query parameter
  #     new_name = String.slice(current_name, 0..-2)
  #     player_query_where = Keyword.put(player_query_where, :name, new_name)
  #     player_query = Keyword.put(player_query, :order_by, player_query_where)
  #     query = Keyword.put(query, :player, player_query)
  #     {:noreply, assign(socket, query: query)}
  #   end
  # end

  # # there's no is_character guard?
  # def handle_event("search_player_keydown", %{"key" => key}, socket) do
  #   # update socket state
  #   query = socket.assigns.query
  #   player_query = Keyword.get(query, :player, [])
  #   player_query_where = Keyword.get(player_query, :where, [])
  #   current_name = Keyword.get(player_query_where, :name, "")

  #   if String.match?(key, ~r/^[[:alpha:]]$/) do
  #     # update the socket's query parameter
  #     new_name = current_name <> key
  #     player_query_where = Keyword.put(player_query_where, :name, new_name)
  #     player_query = Keyword.put(player_query, :where, player_query_where)
  #     query = Keyword.put(query, :player, player_query)
  #    {:noreply, assign(socket, query: query)}
  #   else
  #     # got a weird key
  #     IO.puts("Keydown got a weird character: #{key}")
  #     {:noreply, socket}
  #   end
  # end


  @doc """
  Helper for assigning a new Player's name to filter by.
  """
  defp update_query_with_new_player_name(query, player_name) do
    player_query = Keyword.get(query, :player, [])
    player_query_where = Keyword.get(player_query, :where, [])

    # NOTE: interestingly, we can't refactor the code within the ifs
    # because (assuming since everything is immutable) variables assigned
    # within the if-block do not persist outside (they will take their previous value)
    if player_name != nil and String.length(String.trim(player_name)) > 0 do
      # player name contains non-whitespace characters
      # so, update the filter with the inputed (unsanitized) name
      player_query_where = Keyword.put(player_query_where, :name, player_name)
      player_query = Keyword.put(player_query, :where, player_query_where)
      query = Keyword.put(query, :player, player_query)
      query
    else
      # player name is either nil, empty, or whitespace(s)
      # remove the filter
      player_query_where = Keyword.delete(player_query_where, :name)
      player_query = Keyword.put(player_query, :where, player_query_where)
      query = Keyword.put(query, :player, player_query)
      query
    end
  end

  def update_players(query, socket) do
    # get the query parameters
    filtered_players = Football.list_players(query)
    {:noreply, assign(socket, player: filtered_players, query: query)}
  end
end
