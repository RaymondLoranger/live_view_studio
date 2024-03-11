defmodule LiveView.StudioWeb.SandboxZipForm do
  use LiveView.StudioWeb, [:live_component, :imports, :aliases]

  import SandboxComponents

  @spec mount(Socket.t()) :: {:ok, Socket.t()}
  def mount(socket) do
    {:ok, assign(socket, zip: nil)}
  end

  @spec update(Socket.assigns(), Socket.t()) :: {:ok, Socket.t()}
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:amount, number_to_currency(assigns.fee))}
  end

  @spec render(Socket.assigns()) :: Rendered.t()
  def render(assigns) do
    ~H"""
    <article id={"#{@id}-component"}>
      <.zip_form id={@id} change="change" target={@myself}>
        <.dim_field
          name="zip"
          label="Zip Code:"
          placeholder="Zip Code"
          min="0"
          step=""
          value={@zip}
          required={false}
          unit={@amount}
        />
      </.zip_form>
    </article>
    """
  end

  @spec handle_event(event :: binary, LV.unsigned_params(), Socket.t()) ::
          {:noreply, Socket.t()}
  def handle_event("change", %{"zip" => zip} = _params, socket) do
    fee = Sandbox.calculate_fee(zip)
    send(self(), {__MODULE__, :fee, fee})
    {:noreply, assign(socket, zip: zip, amount: number_to_currency(fee))}
  end
end
