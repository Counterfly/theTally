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

    {:ok, assign(socket, players: players, query: query)}
    # case Football.list_players() do
    #   [players] ->
    #     {:ok, assign(socket, players: players)}

    #   nil ->
    #     # error, redirect to error page
    #     {:ok, redirect(socket, to: "/error")}
    # end
  end

  def handle_info(:update, socket) do
    # nothing to do, just
    Process.send_after(self(), :update, 30000)
    # {:ok, temperature} = Thermostat.get_reading(socket.assigns.user_id)
    {:noreply, socket}
  end

  def handle_event("toggleLng", _, socket) do
    query = socket.assigns.query
    rush_query = Keyword.get(query, :rushing, [])
    rush_query_order_by = Keyword.get(rush_query, :order_by, [])
    value = Keyword.get(rush_query_order_by, :longest_run, nil)
    # since there are 3 states (no sorting, ascending, descending)
    value = transition_sort(value)

    rush_query_order_by = Keyword.put(rush_query_order_by, :longest_run, value)
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
  Returns the next transition state for sortng given the current `sort_order`.

  Transition: nil (no order) -> ASC -> DESC -> nil
  """
  defp transition_sort(sort_order) when is_atom(sort_order) do
    case sort_order do
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
    IO.puts("Search!!! - #{name}")
    IO.inspect(name)
    update_players(socket.assigns.query, socket)
  end

  @doc """
  Keydown was paused because it needs to be more robust.
  Known failing:
    CMD+a Backspace (select-all backspace) deletes everything but this only deletes the last character
  """
  # def handle_event("search_player_keydown", %{"key" => "Enter"}, socket) do
  #   # submit a new query
  #   IO.puts("Keydown ENTER!!!")
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
  #     IO.puts("BACKSPACING! #{current_name}")
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
  #     IO.puts("Keydown got a good character: #{key}")
  #     new_name = current_name <> key
  #     player_query_where = Keyword.put(player_query_where, :name, new_name)
  #     player_query = Keyword.put(player_query, :where, player_query_where)
  #     query = Keyword.put(query, :player, player_query)
  #     IO.inspect(query)
  #    {:noreply, assign(socket, query: query)}
  #   else
  #     # got a weird key
  #     IO.puts("Keydown got a weird character: #{key}")
  #     {:noreply, socket}
  #   end
  # end


  defp update_socket_with_new_player_name(player_name, socket) do
    query = socket.assigns.query
    player_query = Keyword.get(query, :player, [])
    player_query_where = Keyword.get(player_query, :where, [])

    player_query_where = Keyword.put(player_query_where, :name, player_name)
    player_query = Keyword.put(player_query, :where, player_query_where)
    query = Keyword.put(query, :player, player_query)
    query
  end

  def update_players(query, socket) do
    # get the query parameters
    filtered_players = Football.list_players(query)
    {:noreply, assign(socket, players: filtered_players, query: query)}
  end
end
