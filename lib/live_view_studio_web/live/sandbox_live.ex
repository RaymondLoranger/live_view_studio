defmodule LiveView.StudioWeb.SandboxLive do
  use LiveView.StudioWeb, [:live_view, :aliases]

  import SandboxComponents

  @spec mount(LV.unsigned_params(), map, Socket.t()) :: {:ok, Socket.t()}
  def mount(_params, _session, socket) do
    socket = assign(socket, weight: nil, price: nil, fee: 0.0, material: nil)
    {:ok, assign(socket, page_title: "Sandbox")}
  end

  @spec render(Socket.assigns()) :: Rendered.t()
  def render(assigns) do
    ~H"""
    <.focus_wrap id="sandbox-focus-wrap">
      <.sandbox id="sandbox" header="🏝️ Build A Sandbox 🏖️">
        <.live_component module={SandboxForm} id="sandbox-form" />
        <.live_component
          module={SandboxZipForm}
          id="sandbox-zip-form"
          fee={@fee}
        />
        <.sandbox_quote
          :if={@weight}
          weight={@weight}
          price={@price}
          fee={@fee}
          material={@material}
        />
      </.sandbox>
    </.focus_wrap>
    """
  end

  @spec handle_info(msg :: term, Socket.t()) :: {:noreply, Socket.t()}
  def handle_info({SandboxForm, :totals, weight, price, material}, socket) do
    {:noreply, assign(socket, weight: weight, price: price, material: material)}
  end

  def handle_info({SandboxZipForm, :fee, fee}, socket) do
    {:noreply, assign(socket, fee: fee)}
  end

  def handle_info(msg, socket) do
    IO.inspect(msg, label: "::: Unexpected msg ::")
    {:noreply, socket}
  end
end
