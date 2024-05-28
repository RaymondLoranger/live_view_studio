defmodule LiveView.StudioWeb.SalesLive do
  use LiveView.StudioWeb, [:live_view, :aliases]

  import SalesComponents

  @spec mount(LV.unsigned_params(), map, Socket.t()) :: {:ok, Socket.t()}
  def mount(_params, _session, socket) do
    socket = assign_stats(socket) |> assign(refresh: 5, page_title: "Sales")
    if connected?(socket), do: schedule_refresh(socket)
    {:ok, socket}
  end

  @spec render(Socket.assigns()) :: Rendered.t()
  def render(assigns) do
    ~H"""
    <.sales id="sales" header="Snappy Sales 📊">
      <.stats>
        <.stat label="New Orders" id="orders" value={@new_orders} />
        <.stat label="Sales Amount" id="amount" value={"$#{@sales_amount}"} />
        <.stat label="Satisfaction" id="rating" value={"#{@satisfaction}%"} />
      </.stats>

      <.focus_wrap id="controls-focus-wrap">
        <.controls id="controls">
          <.refresh_form id="refresh-form" change="select-refresh">
            <.refresh_label for="refresh" />
            <.refresh_select name="refresh" refresh={@refresh} />
          </.refresh_form>

          <.refresh_button click="refresh" />
        </.controls>
      </.focus_wrap>

      <.last_update last_update={@last_updated_at} />
    </.sales>
    """
  end

  @spec handle_event(event :: binary, LV.unsigned_params(), Socket.t()) ::
          {:noreply, Socket.t()}
  def handle_event("select-refresh", %{"refresh" => refresh}, socket) do
    {:noreply, assign(socket, refresh: String.to_integer(refresh))}
  end

  def handle_event("refresh", _params, socket) do
    {:noreply, assign_stats(socket)}
  end

  @spec handle_info(msg :: term, Socket.t()) :: {:noreply, Socket.t()}
  def handle_info(:tick, socket) do
    schedule_refresh(socket)
    {:noreply, assign_stats(socket)}
  end

  def handle_info(msg, socket) do
    IO.inspect(msg, label: "::: unexpected msg ::")
    {:noreply, socket}
  end

  ## Private functions

  @spec schedule_refresh(Socket.t()) :: reference
  defp schedule_refresh(%Socket{assigns: %{refresh: refresh}} = _socket) do
    # :timer.send_interval/3 continues to send a message at a given interval
    # while Process.send_after/3 sends a single message after a certain time.
    Process.send_after(self(), :tick, refresh * 1000)
  end

  @spec assign_stats(Socket.t()) :: Socket.t()
  defp assign_stats(socket) do
    assign(socket,
      new_orders: Sales.new_orders(),
      sales_amount: Sales.sales_amount(),
      satisfaction: Sales.satisfaction(),
      last_updated_at: Timex.now("America/New_York")
    )
  end
end
