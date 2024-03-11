defmodule LiveView.StudioWeb.VolunteerItem do
  use LiveView.StudioWeb, [:live_component, :aliases]

  import VolunteersComponents

  @spec render(Socket.assigns()) :: Rendered.t()
  def render(assigns) do
    ~H"""
    <article id={"#{@id}-component"}>
      <.volunteer_item id={@id} volunteer={@volunteer}>
        <.item_name volunteer={@volunteer} />
        <.item_phone volunteer={@volunteer} />
        <.check_in_out_button
          volunteer={@volunteer}
          click="toggle-status"
          id={@volunteer.id}
          target={@myself}
          disable_with="Saving..."
        />
        <.delete_icon click="delete" id={@volunteer.id} target={@myself} />
      </.volunteer_item>
    </article>
    """
  end

  @spec handle_event(event :: binary, LV.unsigned_params(), Socket.t()) ::
          {:noreply, Socket.t()}
  def handle_event("toggle-status", %{"id" => id}, socket) do
    {:ok, _volunteer} = Volunteers.toggle_status_volunteer(id)
    # Wait to see swapped text during event submission...
    # :timer.sleep(250)
    {:noreply, socket}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    {:ok, _volunteer} = Volunteers.delete_volunteer(id)
    {:noreply, socket}
  end
end
