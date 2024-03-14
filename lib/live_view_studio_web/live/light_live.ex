defmodule LiveView.StudioWeb.LightLive do
  use LiveView.StudioWeb, [:live_view, :aliases]

  import LightComponents

  @temps [3000, 4000, 5000, 6000]

  @spec mount(LV.unsigned_params(), map, Socket.t()) :: {:ok, Socket.t()}
  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       page_title: "Light",
       brightness: Enum.random(10..90),
       temp: Enum.random(@temps),
       temps: @temps,
       # Initially slider is blurred...
       blur: true
     )}
  end

  @spec render(Socket.assigns()) :: Rendered.t()
  def render(assigns) do
    ~H"""
    <.light
      id="front-porch-light"
      keyup="update"
      header="💡 Front Porch Light 💡"
      subtitle="⇑ = up, ⇓ = down"
    >
      <.meter temp={@temp} brightness={@brightness} />
      <.focus_wrap id="control-focus-wrap">
        <.btn click="off" svg="light-off" disabled={@brightness == 0} />
        <.btn click="down" svg="down" disabled={@brightness == 0} />
        <.btn click="random" svg="fire" />
        <.btn click="up" svg="up" disabled={@brightness == 100} />
        <.btn click="on" svg="light-on" disabled={@brightness == 100} />
        <.slider
          brightness={@brightness}
          focus="focus"
          blur="blur"
          change="set"
        />
        <.selector temps={@temps} temp={@temp} change="switch-temp" />
      </.focus_wrap>
    </.light>
    """
  end

  @spec handle_event(event :: binary, LV.unsigned_params(), Socket.t()) ::
          {:noreply, Socket.t()}
  def handle_event("focus", _params, socket) do
    {:noreply, assign(socket, :blur, false)}
  end

  def handle_event("blur", _params, socket) do
    {:noreply, assign(socket, :blur, true)}
  end

  def handle_event("set", %{"brightness" => brightness}, socket) do
    {:noreply, assign(socket, :brightness, String.to_integer(brightness))}
  end

  def handle_event("update", %{"key" => "ArrowUp"}, socket)
      when socket.assigns.blur do
    {:noreply, update(socket, :brightness, &up/1)}
  end

  def handle_event("update", %{"key" => "ArrowDown"}, socket)
      when socket.assigns.blur do
    {:noreply, update(socket, :brightness, &down/1)}
  end

  # Catch-all clause for other keys.
  def handle_event("update", %{"key" => key}, socket) do
    IO.inspect(key, label: "::: key ignored ::")
    {:noreply, socket}
  end

  def handle_event("off", _params, socket) do
    {:noreply, assign(socket, :brightness, 0)}
  end

  def handle_event("down", _params, socket) do
    {:noreply, update(socket, :brightness, &down/1)}
  end

  def handle_event("random", _params, socket) do
    {:noreply, assign(socket, :brightness, Enum.random(0..100))}
  end

  def handle_event("up", _params, socket) do
    {:noreply, update(socket, :brightness, &up/1)}
  end

  def handle_event("on", _params, socket) do
    {:noreply, assign(socket, :brightness, 100)}
  end

  def handle_event("switch-temp", %{"temp" => temp}, socket) do
    {:noreply, assign(socket, :temp, String.to_integer(temp))}
  end

  ## Private functions

  @spec up(non_neg_integer) :: non_neg_integer
  defp up(brightness), do: min(brightness + 10, 100)

  @spec down(non_neg_integer) :: non_neg_integer
  defp down(brightness), do: max(brightness - 10, 0)
end
