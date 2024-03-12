defmodule LiveView.StudioWeb.ChartLive do
  use LiveView.StudioWeb, [:live_view, :aliases]

  import ChartComponents

  @last_label 12
  @labels Enum.to_list(1..@last_label)

  @spec mount(LV.unsigned_params(), map, Socket.t()) :: {:ok, Socket.t()}
  def mount(_params, _session, socket) do
    if connected?(socket), do: :timer.send_interval(1000, :update)
    values = Enum.map(@labels, &get_reading/1)
    chart = %{labels: @labels, values: values} |> Jason.encode!()
    socket = assign(socket, :page_title, "Chart")
    {:ok, assign(socket, chart: chart, last_label: @last_label)}
  end

  @spec render(Socket.assigns()) :: Rendered.t()
  def render(assigns) do
    ~H"""
    <.chart>
      <.canvas_header text="Blood Sugar" />

      <.canvas_wrapper update="ignore">
        <.canvas hook="LineChart" chart={@chart} />
      </.canvas_wrapper>

      <.canvas_footer>
        <.chart_button click="get-reading" />
        <.total_readings last_label={@last_label} />
      </.canvas_footer>
    </.chart>
    """
  end

  @spec handle_event(event :: binary, LV.unsigned_params(), Socket.t()) ::
          {:noreply, Socket.t()}
  def handle_event("get-reading", _params, socket) do
    {:noreply, add_point(socket)}
  end

  @spec handle_info(msg :: term, Socket.t()) :: {:noreply, Socket.t()}
  def handle_info(:update, socket) do
    {:noreply, add_point(socket)}
  end

  ## Private functions

  @spec add_point(Socket.t()) :: Socket.t()
  defp add_point(socket) do
    socket = update(socket, :last_label, &(&1 + 1))
    last_label = socket.assigns.last_label
    point = %{label: last_label, value: get_reading(last_label)}
    push_event(socket, "new-point", point)
  end

  @spec get_reading(pos_integer) :: pos_integer
  defp get_reading(label) do
    Enum.random(70..180) + Enum.random(-label..label)
  end
end
