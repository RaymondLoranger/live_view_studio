defmodule LiveView.StudioWeb.FlightsLive do
  use LiveView.StudioWeb, [:live_view, :aliases]

  import FlightsComponents

  @spec mount(LV.unsigned_params(), map, Socket.t()) ::
          {:ok, Socket.t(), keyword}
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign_fields(false, "", "", [])
      |> assign(
        routes: Flights.routes(),
        airports: Airports.prefixed(""),
        page_title: "Flights"
      )

    # Contrarily to [], nil allows to properly handle events returning []...
    {:ok, socket, temporary_assigns: [flights: nil]}
  end

  @spec render(Socket.assigns()) :: Rendered.t()
  def render(assigns) do
    ~H"""
    <.focus_wrap id="flights-focus-wrap">
      <.flights id="flights" header="Find a Flight ✈️">
        <.flight_number_form change="capture" submit="search">
          <.flight_number_field
            number={@number}
            searching={@searching}
            routes={@routes}
          />
          <.search_submit_button />
        </.flight_number_form>

        <.airport_code_form change="capture" submit="search">
          <.airport_code_field
            code={@code}
            searching={@searching}
            airports={@airports}
          />
          <.search_submit_button />
        </.airport_code_form>

        <:search_results>
          <.search_in_progress visible={@searching} />
          <.flights_found id="flights-found" update="replace">
            <.flight_found
              :for={flight <- @flights}
              id={"flight-#{flight.id}"}
              flight={flight}
            />
          </.flights_found>
        </:search_results>
      </.flights>
    </.focus_wrap>
    """
  end

  @spec handle_event(event :: binary, LV.unsigned_params(), Socket.t()) ::
          {:noreply, Socket.t()}
  def handle_event("capture", %{"number" => start}, socket) do
    {:noreply, assign_fields(socket, false, start, socket.assigns.code)}
  end

  def handle_event("capture", %{"code" => start}, socket) do
    {:noreply,
     socket
     |> assign_fields(false, socket.assigns.number, start)
     |> assign(airports: Airports.prefixed(start))}
  end

  def handle_event("search", %{"number" => number} = params, socket) do
    send(self(), {:search, params})
    {:noreply, assign_fields(socket, true, number, socket.assigns.code, [])}
  end

  def handle_event("search", %{"code" => code} = params, socket) do
    send(self(), {:search, params})
    {:noreply, assign_fields(socket, true, socket.assigns.number, code, [])}
  end

  @spec handle_info(msg :: term, Socket.t()) :: {:noreply, Socket.t()}
  def handle_info({:search, %{"number" => number}}, socket) do
    {:noreply,
     assign_flights(socket, number, Flights.search_by_flight_number(number))}
  end

  def handle_info({:search, %{"code" => code}}, socket) do
    {:noreply,
     assign_flights(socket, code, Flights.search_by_airport_code(code))}
  end

  ## Private functions

  @spec assign_flights(Socket.t(), Flights.flight_number_or_airport_code(), [
          Flights.flight()
        ]) :: Socket.t()
  defp assign_flights(socket, flight_number_or_airport_code, _flights = []) do
    socket
    |> put_flash(
      :error,
      ~s|No flights matching "#{flight_number_or_airport_code}"|
    )
    |> assign(flights: [], searching: false)
  end

  defp assign_flights(socket, _flight_number_or_airport_code, flights) do
    socket |> clear_flash() |> assign(flights: flights, searching: false)
  end

  @spec assign_fields(
          Socket.t(),
          boolean,
          Flights.flight_number(),
          Flights.airport_code()
        ) :: Socket.t()
  defp assign_fields(socket, searching, number, code) do
    assign(socket, searching: searching, number: number, code: code)
  end

  @spec assign_fields(
          Socket.t(),
          boolean,
          Flights.flight_number(),
          Flights.airport_code(),
          [Flights.flight()]
        ) :: Socket.t()
  defp assign_fields(socket, searching, number, code, flights) do
    socket |> assign_fields(searching, number, code) |> assign(flights: flights)
  end
end
