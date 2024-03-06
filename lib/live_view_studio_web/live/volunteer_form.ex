defmodule LiveView.StudioWeb.VolunteerForm do
  use LiveView.StudioWeb, [:live_component, :aliases]

  import VolunteersComponents

  @empty_form Volunteers.change_volunteer(%Volunteer{}) |> to_form()
  @empty_payload %{"volunteer" => %{"name" => "", "phone" => ""}}

  @spec mount(Socket.t()) :: {:ok, Socket.t()}
  def mount(socket) do
    {:ok, assign(socket, :form, @empty_form)}
  end

  @spec update(Socket.assigns(), Socket.t()) :: {:ok, Socket.t()}
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:count, assigns.count + 1)}
  end

  @spec render(Socket.assigns()) :: Rendered.t()
  def render(assigns) do
    ~H"""
    <article>
      <.prompt count={@count} />
      <.focus_wrap id="volunteer-form-focus-wrap">
        <.volunteer_form
          id="volunteer-form"
          for={@form}
          target={@myself}
          change="validate"
          submit="save"
        >
          <.name form={@form} />
          <.phone form={@form} />
          <.check_in_button disable_with="Saving..." />
        </.volunteer_form>
      </.focus_wrap>
    </article>
    """
  end

  @spec handle_event(event :: binary, LV.unsigned_params(), Socket.t()) ::
          {:noreply, Socket.t()}
  def handle_event("save", %{"volunteer" => params}, socket) do
    case Volunteers.create_volunteer(params) do
      {:ok, _volunteer} ->
        # Wait to see swapped text during event submission...
        # :timer.sleep(250)
        {:noreply, assign(socket, :form, @empty_form)}

      {:error, changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  def handle_event("validate", @empty_payload, socket) do
    {:noreply, assign(socket, :form, @empty_form)}
  end

  def handle_event("validate", %{"volunteer" => params}, socket) do
    changeset = Volunteers.validate(%Volunteer{}, params)
    {:noreply, assign(socket, :form, to_form(changeset))}
  end
end
