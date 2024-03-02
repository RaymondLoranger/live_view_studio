defmodule LiveView.StudioWeb.SandboxForm do
  use LiveView.StudioWeb, [:live_component, :aliases]

  import SandboxComponents

  @spec mount(Socket.t()) :: {:ok, Socket.t()}
  def mount(socket) do
    {:ok, assign(socket, length: nil, width: nil, depth: nil, weight: 0.0)}
  end

  @spec render(Socket.assigns()) :: Rendered.t()
  def render(assigns) do
    ~H"""
    <article>
      <.sandbox_form target={@myself} change="calc-weight" submit="calc-price">
        <.dim_field
          name="length"
          label="Length:"
          placeholder="Length"
          value={@length}
          unit="feet"
        />
        <.dim_field
          name="width"
          label="Width:"
          placeholder="Width"
          value={@width}
          unit="feet"
        />
        <.dim_field
          name="depth"
          label="Depth:"
          placeholder="Depth"
          value={@depth}
          unit="inches"
        />
        <.weight_calculated weight={@weight} />
        <.calculate_quote_button />
      </.sandbox_form>
    </article>
    """
  end

  @spec handle_event(event :: binary, LV.unsigned_params(), Socket.t()) ::
          {:noreply, Socket.t()}
  def handle_event(
        "calc-weight",
        %{"length" => l, "width" => w, "depth" => d} = _params,
        socket
      ) do
    send(self(), {__MODULE__, :totals, nil, 0.0})
    weight = Sandbox.calculate_weight(l, w, d)
    {:noreply, assign(socket, length: l, width: w, depth: d, weight: weight)}
  end

  def handle_event(
        "calc-price",
        _params,
        %Socket{assigns: %{weight: weight}} = socket
      ) do
    price = Sandbox.calculate_price(weight)
    send(self(), {__MODULE__, :totals, weight, price})
    {:noreply, socket}
  end
end
