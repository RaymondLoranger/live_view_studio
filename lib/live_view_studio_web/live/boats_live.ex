defmodule LiveView.StudioWeb.BoatsLive do
  use LiveView.StudioWeb, [:live_view, :aliases]

  import BoatsComponents

  @spec mount(LV.unsigned_params(), map, Socket.t()) ::
          {:ok, Socket.t(), keyword}
  def mount(_params, _session, socket) do
    socket = assign(socket, :page_title, "Boats")
    # Contrarily to [], nil allows to properly handle events returning []...
    {:ok, assign_defaults(socket), temporary_assigns: [boats: nil]}
  end

  @spec render(Socket.assigns()) :: Rendered.t()
  def render(assigns) do
    ~H"""
    <.boats id="boats" header="Daily Boat Rentals ⛵">
      <.focus_wrap id="filter-form-focus-wrap">
        <.filter_form id="filter-form" change="filter">
          <.select_type type={@type} />
          <.check_prices prices={@prices} />
          <.clear_button click="clear" />
        </.filter_form>
      </.focus_wrap>

      <.boats_found id="boats-found" update="replace">
        <.boat_found
          :for={boat <- @boats}
          id={"boat-card-#{boat.id}"}
          boat={boat}
        />
      </.boats_found>
    </.boats>
    """
  end

  @spec handle_event(event :: binary, LV.unsigned_params(), Socket.t()) ::
          {:noreply, Socket.t()}
  def handle_event("filter", %{"type" => type, "prices" => prices}, socket) do
    filter = %{type: type, prices: prices}
    send(self(), {:filter, filter})
    {:noreply, socket |> clear_flash() |> assign(filter)}
  end

  def handle_event("clear", _params, socket) do
    {:noreply, assign_defaults(socket)}
  end

  @spec handle_info(msg :: term, Socket.t()) :: {:noreply, Socket.t()}
  def handle_info({:filter, %{type: _, prices: _} = filter}, socket) do
    # Process.sleep(500)
    {:noreply, assign_boats(socket, Boats.list_boats(filter))}
  end

  ## Private functions

  @spec assign_defaults(Socket.t()) :: Socket.t()
  defp assign_defaults(socket) do
    assign(socket, boats: Boats.list_boats(), type: "", prices: [])
  end

  @spec assign_boats(Socket.t(), [%Boat{}]) :: Socket.t()
  defp assign_boats(socket, _boats = []) do
    socket |> put_flash(:error, "No matching boats...") |> assign(boats: [])
  end

  defp assign_boats(socket, boats) do
    assign(socket, boats: boats)
  end
end
