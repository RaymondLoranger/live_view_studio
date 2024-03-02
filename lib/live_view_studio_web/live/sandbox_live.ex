defmodule LiveView.StudioWeb.SandboxLive do
  use LiveView.StudioWeb, [:live_view, :aliases]

  import SandboxComponents

  @spec mount(LV.unsigned_params(), map, Socket.t()) :: {:ok, Socket.t()}
  def mount(_params, _session, socket) do
    {:ok,
     assign(socket, weight: nil, price: 0.00, fee: 0.00, page_title: "Sandbox")}
  end

  @spec render(Socket.assigns()) :: Rendered.t()
  def render(assigns) do
    ~H"""
    <.focus_wrap id="sandbox-focus-wrap">
      <.sandbox id="sandbox" header="🏝️ Build A Sandbox 🏖️">
        <.live_component module={SandboxForm} id="sandbox-form" />
        <.live_component module={SandboxFeeForm} id="sandbox-fee-form" />
        <.sandbox_quote
          :if={@weight}
          weight={@weight}
          price={@price}
          fee={@fee}
        />
      </.sandbox>
    </.focus_wrap>
    """
  end

  @spec handle_info(msg :: term, Socket.t()) :: {:noreply, Socket.t()}
  def handle_info({SandboxForm, :totals, weight, price}, socket) do
    {:noreply, assign(socket, weight: weight, price: price)}
  end

  def handle_info({SandboxFeeForm, :fee, fee}, socket) do
    {:noreply, assign(socket, fee: fee)}
  end

  def handle_info(msg, socket) do
    IO.inspect(msg, label: "::: Unexpected msg ::")
    {:noreply, socket}
  end
end
