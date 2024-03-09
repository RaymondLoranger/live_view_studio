defmodule LiveView.StudioWeb.DesksLive do
  use LiveView.StudioWeb, [:live_view, :imports, :aliases]

  import DesksComponents

  @spec mount(LV.unsigned_params(), map, Socket.t()) ::
          {:ok, Socket.t()}
  def mount(_params, _session, socket) do
    if connected?(socket), do: Desks.subscribe()

    {:ok,
     socket
     |> assign(:page_title, "Desk Photos")
     |> stream(:desks, Desks.list_desks_by_desc_id())}
  end

  @spec render(Socket.assigns()) :: Rendered.t()
  def render(assigns) do
    ~H"""
    <.desks id="desks" header="What's On Your Desk?">
      <.live_component module={DeskForm} id="desk-form" />

      <.all_photos id="photos" update="stream">
        <.desk_photos :for={{dom_id, desk} <- @streams.desks} id={dom_id}>
          <.desk_photo
            :for={{photo_location, index} <- with_index(desk.photo_locations)}
            desk={desk}
            index={index}
            photo_location={photo_location}
          />
        </.desk_photos>
      </.all_photos>
    </.desks>
    """
  end

  @spec handle_info(msg :: term, Socket.t()) :: {:noreply, Socket.t()}
  def handle_info({Desks, :desk_created, desk}, socket) do
    {:noreply, stream_insert(socket, :desks, desk, at: 0)}
  end
end
