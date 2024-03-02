defmodule LiveView.StudioWeb.SandboxFeeForm do
  use LiveView.StudioWeb, [:live_component, :imports, :aliases]

  import SandboxComponents

  @spec mount(Socket.t()) :: {:ok, Socket.t()}
  def mount(socket) do
    {:ok, assign(socket, zip: nil, amount: number_to_currency(0))}
  end

  @spec render(Socket.assigns()) :: Rendered.t()
  def render(assigns) do
    ~H"""
    <article>
      <.zip_form change="calc-fee" target={@myself}>
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
  def handle_event("calc-fee", %{"zip" => zip}, socket) do
    fee = Sandbox.calculate_fee(zip)
    send(self(), {__MODULE__, :fee, fee})
    {:noreply, assign(socket, zip: zip, amount: number_to_currency(fee))}
  end
end
