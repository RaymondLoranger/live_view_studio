defmodule LiveView.StudioWeb.StoresLive do
  use LiveView.StudioWeb, [:live_view, :aliases]

  import StoresComponents

  @spec mount(LV.unsigned_params(), map, Socket.t()) ::
          {:ok, Socket.t(), keyword}
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign_fields(false, "", "", [])
      |> assign(
        areas: Stores.areas(),
        cities: Cities.prefixed(""),
        page_title: title(socket.assigns.live_action)
      )

    # Contrarily to [], nil allows to properly handle events returning []...
    {:ok, socket, temporary_assigns: [stores: nil]}
  end

  @spec render(Socket.assigns()) :: Rendered.t()
  def render(assigns) do
    ~H"""
    <.focus_wrap id="stores-focus-wrap">
      <.stores id="stores" header="Find a Store 🛍️">
        <.zip_form id="zip-form" change="zip-change" submit="zip-search">
          <.zip_field zip={@zip} searching={@searching} areas={@areas} />
          <.search_submit_button />
        </.zip_form>

        <.city_form
          :if={@live_action == :autocomplete}
          id="city-form"
          change="city-change"
          submit="city-search"
        >
          <.city_field city={@city} searching={@searching} cities={@cities} />
          <.search_submit_button />
        </.city_form>

        <.search_in_progress visible={@searching} />

        <.stores_found id="stores-found" update="replace">
          <.store_found :for={store <- @stores} id={"store-#{store.id}"}>
            <.store_first_line store={store} />
            <.store_second_line store={store} />
          </.store_found>
        </.stores_found>
      </.stores>
    </.focus_wrap>
    """
  end

  @spec handle_event(event :: binary, LV.unsigned_params(), Socket.t()) ::
          {:noreply, Socket.t()}
  def handle_event("zip-change", %{"zip" => start}, socket) do
    {:noreply, assign_fields(socket, false, start, socket.assigns.city)}
  end

  def handle_event("city-change", %{"city" => start}, socket) do
    {:noreply,
     socket
     |> assign_fields(false, socket.assigns.zip, start)
     |> assign(cities: Cities.prefixed(start))}
  end

  def handle_event("zip-search", %{"zip" => zip}, socket) do
    send(self(), {:run_zip_search, zip})
    {:noreply, assign_fields(socket, true, zip, socket.assigns.city, [])}
  end

  def handle_event("city-search", %{"city" => city}, socket) do
    send(self(), {:run_city_search, city})
    {:noreply, assign_fields(socket, true, socket.assigns.zip, city, [])}
  end

  @spec handle_info(msg :: term, Socket.t()) :: {:noreply, Socket.t()}
  def handle_info({:run_zip_search, zip}, socket) do
    {:noreply, assign_stores(socket, zip, Stores.search_by_zip(zip))}
  end

  def handle_info({:run_city_search, city}, socket) do
    {:noreply, assign_stores(socket, city, Stores.search_by_city(city))}
  end

  ## Private functions

  @spec assign_stores(Socket.t(), Stores.zip_or_city(), [Stores.store()]) ::
          Socket.t()
  defp assign_stores(socket, zip_or_city, _stores = []) do
    socket
    |> put_flash(:error, ~s|No stores matching "#{zip_or_city}"|)
    |> assign(stores: [], searching: false)
  end

  defp assign_stores(socket, _zip_or_city, stores) do
    socket |> clear_flash() |> assign(stores: stores, searching: false)
  end

  @spec assign_fields(Socket.t(), boolean, Stores.zip(), Stores.city()) ::
          Socket.t()
  defp assign_fields(socket, searching, zip, city) do
    assign(socket, searching: searching, zip: zip, city: city)
  end

  @spec assign_fields(Socket.t(), boolean, Stores.zip(), Stores.city(), [
          Stores.store()
        ]) :: Socket.t()
  defp assign_fields(socket, searching, zip, city, stores) do
    socket |> assign_fields(searching, zip, city) |> assign(stores: stores)
  end

  @spec title(action :: atom) :: String.t()
  defp title(nil), do: "Stores"
  defp title(:autocomplete), do: "Autocomplete"
end
