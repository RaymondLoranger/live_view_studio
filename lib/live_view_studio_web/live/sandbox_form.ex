defmodule LiveView.StudioWeb.SandboxForm do
  use LiveView.StudioWeb, [:live_component, :aliases]

  import SandboxComponents

  @spec mount(Socket.t()) :: {:ok, Socket.t()}
  def mount(socket) do
    {:ok,
     assign(socket,
       length: nil,
       width: nil,
       depth: nil,
       weight: 0.0,
       material: "sand"
     )}
  end

  @spec render(Socket.assigns()) :: Rendered.t()
  def render(assigns) do
    ~H"""
    <article id={"#{@id}-component"}>
      <.sandbox_form id={@id} target={@myself} change="change" submit="submit">
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
        <.select_material
          name="material"
          label="Material:"
          value={@material}
          unit="select"
        />
        <.what_you_need weight={@weight} material={@material} />
        <.calculate_quote_button />
      </.sandbox_form>
    </article>
    """
  end

  @spec handle_event(event :: binary, LV.unsigned_params(), Socket.t()) ::
          {:noreply, Socket.t()}
  def handle_event(
        "change",
        %{"length" => l, "width" => w, "depth" => d, "material" => m} = _params,
        socket
      ) do
    send(self(), {__MODULE__, :totals, nil, nil, nil})
    weight = Sandbox.calculate_weight(l, w, d)

    {:noreply,
     assign(socket, length: l, width: w, depth: d, material: m, weight: weight)}
  end

  def handle_event(
        "submit",
        _params,
        %Socket{assigns: %{weight: weight, material: material}} = socket
      ) do
    price = Sandbox.calculate_price(weight)
    send(self(), {__MODULE__, :totals, weight, price, material})
    {:noreply, socket}
  end
end
