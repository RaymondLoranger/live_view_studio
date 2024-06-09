defmodule LiveView.StudioWeb.ServerForm do
  use LiveView.StudioWeb, [:live_component, :aliases]

  import ServersComponents

  @empty_form Servers.change_server(%Server{}) |> to_form()
  @empty_payload %{
    "server" => %{
      "name" => "",
      "framework" => "",
      "size" => "",
      "git_repo" => ""
    }
  }

  @spec mount(Socket.t()) :: {:ok, Socket.t()}
  def mount(socket) do
    {:ok, assign(socket, form: @empty_form)}
  end

  @spec update(Socket.assigns(), Socket.t()) :: {:ok, Socket.t()}
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:class, fn -> nil end)
     |> assign_new(:on_cancel, fn -> "" end)
     |> assign_new(:inside_modal, fn -> false end)}
  end

  @spec render(Socket.assigns()) :: Rendered.t()
  def render(assigns) do
    ~H"""
    <article id={"#{@id}-component"}>
      <.server_form
        id={@id}
        for={@form}
        target={@myself}
        submit="save"
        change="validate"
        class={@class}
      >
        <.focus_wrap :if={!@inside_modal} id="server-form-focus-wrap">
          <.close_icon patch={@on_cancel} />
          <.name form={@form} />
          <.framework form={@form} />
          <.size form={@form} />
          <.git_repo form={@form} />
          <.buttons disable_with="Saving..." patch={@on_cancel} />
        </.focus_wrap>

        <div :if={@inside_modal}>
          <.name form={@form} />
          <.framework form={@form} />
          <.size form={@form} />
          <.git_repo form={@form} />
          <.buttons disable_with="Saving..." patch={@on_cancel} />
        </div>
      </.server_form>
    </article>
    """
  end

  @spec handle_event(event :: binary, LV.unsigned_params(), Socket.t()) ::
          {:noreply, Socket.t()}
  def handle_event("save", %{"server" => params}, socket) do
    case Servers.create_server(params) do
      {:ok, _server} ->
        # Wait to see swapped text during event submission...
        # :timer.sleep(250)
        # Parent's handle_info/2 will call push_patch/2...
        {:noreply, assign(socket, :form, @empty_form)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  def handle_event("validate", @empty_payload, socket) do
    {:noreply, assign(socket, :form, @empty_form)}
  end

  def handle_event("validate", %{"server" => params}, socket) do
    changeset = Servers.validate(%Server{}, params)
    {:noreply, assign(socket, :form, to_form(changeset))}
  end
end
