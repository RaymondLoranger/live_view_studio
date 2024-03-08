defmodule LiveView.StudioWeb.JugglingLive do
  use LiveView.StudioWeb, [:live_view, :aliases]

  import JugglingComponents

  @valid_numbers for i <- 0..18, do: "#{i}"
  # => ["0", "1" ... "17", "18"]

  @spec mount(LV.unsigned_params(), map, Socket.t()) ::
          {:ok, Socket.t()}
  def mount(_params, _session, socket) do
    {:ok, assign(socket, current: 0, timer: nil, error: "")}
  end

  @spec render(Socket.assigns()) :: Rendered.t()
  def render(assigns) do
    ~H"""
    <.juggling
      id="juggling"
      window_keyup="update"
      header="🤹‍♀️ Juggling Key Events 🤹‍♀️"
    >
      <.legend text="k = play/pause, ⇐ = previous, ⇒ = next" />

      <.current_image current={@current} />

      <.focus_wrap id="footer-focus-wrap">
        <.footer>
          <.current_file current={@current} />
          <.input_field
            value={@current}
            error={@error}
            keyup="update"
            key="Enter"
          />
          <.mode_button click="toggle-mode" timer={@timer} />
        </.footer>
      </.focus_wrap>
    </.juggling>
    """
  end

  @spec handle_event(event :: binary, LV.unsigned_params(), Socket.t()) ::
          {:noreply, Socket.t()}
  def handle_event("update", %{"key" => "Enter", "value" => number}, socket)
      when number in @valid_numbers do
    {:noreply, assign(socket, :current, String.to_integer(number))}
  end

  def handle_event("update", %{"key" => "Enter", "value" => _?}, socket) do
    Process.send_after(self(), :clear_error, 5000)
    {:noreply, assign(socket, :error, "must be 0 to 18")}
  end

  def handle_event("update", %{"key" => "ArrowLeft"}, socket) do
    {:noreply, assign(socket, :current, previous(socket))}
  end

  def handle_event("update", %{"key" => "ArrowRight"}, socket) do
    {:noreply, assign(socket, :current, next(socket))}
  end

  def handle_event("update", %{"key" => "k"}, socket) do
    {:noreply, assign_timer(socket)}
  end

  def handle_event("update", %{"key" => key}, socket) do
    IO.inspect(key, label: "::: key ignored ::")
    {:noreply, socket}
  end

  def handle_event("toggle-mode", _params, socket) do
    {:noreply, assign_timer(socket)}
  end

  @spec handle_info(msg :: term, Socket.t()) :: {:noreply, Socket.t()}
  def handle_info(:tick, socket) do
    {:noreply, assign(socket, :current, next(socket))}
  end

  def handle_info(:clear_error, socket) do
    {:noreply, assign(socket, :error, "")}
  end

  ## Private functions

  @spec assign_timer(Socket.t()) :: Socket.t()
  defp assign_timer(%Socket{assigns: %{timer: nil}} = socket) do
    # {:ok, timer} = :timer.send_interval(200, self(), :tick)
    {:ok, timer} = :timer.send_interval(200, :tick)
    assign(socket, :timer, timer)
  end

  defp assign_timer(%Socket{assigns: %{timer: timer}} = socket) do
    {:ok, :cancel} = :timer.cancel(timer)
    assign(socket, :timer, nil)
  end

  @spec previous(Socket.t()) :: non_neg_integer
  defp previous(%Socket{assigns: %{current: 0}}), do: 18
  defp previous(%Socket{assigns: %{current: current}}), do: current - 1

  @spec next(Socket.t()) :: non_neg_integer
  defp next(%Socket{assigns: %{current: 18}}), do: 0
  defp next(%Socket{assigns: %{current: current}}), do: current + 1
end
