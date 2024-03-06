defmodule LiveView.StudioWeb.VolunteersLive do
  use LiveView.StudioWeb, [:live_view, :aliases]

  import VolunteersComponents

  @flash_in_ms 5000

  @spec mount(LV.unsigned_params(), map, Socket.t()) ::
          {:ok, Socket.t()}
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Volunteers.subscribe()
      # Only for a :volunteer_created event flash message.
      Process.send_after(self(), :clear_flash, @flash_in_ms)
    end

    volunteers = Volunteers.list_volunteers_by_desc_id()

    {:ok,
     socket
     |> stream(:volunteers, volunteers)
     |> assign(:count, length(volunteers))
     |> assign(:page_title, "Volunteers")}
  end

  @spec render(Socket.assigns()) :: Rendered.t()
  def render(assigns) do
    ~H"""
    <.volunteers id="volunteers" header="Volunteers 🎖️">
      <.live_component
        module={VolunteerForm}
        id="volunteer-form"
        count={@count}
      />
      <.volunteer_items id="volunteer-items" update="stream">
        <.live_component
          :for={{volunteer_id, volunteer} <- @streams.volunteers}
          module={VolunteerItem}
          id={volunteer_id}
          volunteer={volunteer}
        />
      </.volunteer_items>
    </.volunteers>
    """
  end

  @spec handle_info(msg :: term, Socket.t()) :: {:noreply, Socket.t()}
  def handle_info({:volunteer_created = event, volunteer}, socket) do
    {:noreply,
     socket
     |> stream_insert(:volunteers, volunteer, at: 0)
     |> update(:count, &(&1 + 1))
     |> put_flash(:info, message(event, volunteer))
     # ┌────────────────────────────────────────────────────────┐
     # │ Will mount a new LiveView while keeping current layout │
     # │ so the form behaves CONSISTENTLY after initial submit! │
     # └────────────────────────────────────────────────────────┘
     |> push_navigate(to: ~p"/volunteers")}
  end

  def handle_info({:volunteer_updated = event, volunteer}, socket) do
    Process.send_after(self(), :clear_flash, @flash_in_ms)

    {:noreply,
     socket
     |> stream_insert(:volunteers, volunteer)
     |> put_flash(:info, message(event, volunteer))}
  end

  def handle_info({:volunteer_deleted = event, volunteer}, socket) do
    Process.send_after(self(), :clear_flash, @flash_in_ms)

    {:noreply,
     socket
     |> stream_delete(:volunteers, volunteer)
     |> update(:count, &(&1 - 1))
     |> put_flash(:info, message(event, volunteer))}
  end

  def handle_info(:clear_flash, socket) do
    {:noreply, clear_flash(socket)}
  end

  def handle_info(msg, socket) do
    {:noreply, put_flash(socket, :error, unexpected_msg(%{msg: msg}))}
  end

  ## Private functions

  @spec message(atom, %Volunteer{}) :: String.t()
  defp message(:volunteer_created, %Volunteer{name: name, checked_out: false}),
    do: "#{name} checked in to volunteer!"

  defp message(:volunteer_updated, %Volunteer{name: name, checked_out: true}),
    do: "#{name} checked out!"

  defp message(:volunteer_updated, %Volunteer{name: name, checked_out: false}),
    do: "#{name} checked in!"

  defp message(:volunteer_deleted, %Volunteer{name: name}),
    do: "Volunteer #{name} deleted!"
end
