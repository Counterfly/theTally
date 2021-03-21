defmodule TheTallyWeb.FootballLive do
  use TheTallyWeb, :live_view

  alias TheTally.Football

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Process.send_after(self(), :update, 30000)

    players = Football.list_players()

    query = [
      {:players, []},
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
    filtered_players = Football.list_players(query)

    {:noreply, assign(socket, players: filtered_players, query: query)}
  end

  @doc """
  Returns a css class string for a column depending on if it's being sorted.
  """
  def sort_column_class(sort_value) do
    if sort_value != nil do
      "bg-gray-300" # this is a tailwind class
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
end
