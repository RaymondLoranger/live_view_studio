defmodule LiveView.StudioWeb.LicenseLive do
  use LiveView.StudioWeb, [:live_view, :aliases]

  import LicenseComponents

  @spec mount(LV.unsigned_params(), map, Socket.t()) :: {:ok, Socket.t()}
  def mount(_params, _session, socket) do
    if connected?(socket), do: :timer.send_interval(7500, :tick)
    expiration_time = Timex.shift(Timex.now(), hours: 1)

    {:ok,
     assign(socket,
       expiration_time: expiration_time,
       time_remaining: time_remaining(expiration_time),
       seats: 3,
       amount: Licenses.calculate(3),
       page_title: "License"
     )}
  end

  @spec render(Socket.assigns()) :: Rendered.t()
  def render(assigns) do
    ~H"""
    <.license>
      <.card>
        <.content>
          <.seats seats={@seats} />
          <.focus_wrap id="slider-focus-wrap">
            <.slider change="update" seats={@seats} />
          </.focus_wrap>
          <.amount amount={@amount} />
          <.timer time_remaining={@time_remaining} />
        </.content>
      </.card>
    </.license>
    """
  end

  @spec handle_info(msg :: term, Socket.t()) :: {:noreply, Socket.t()}
  def handle_info(:tick, socket) do
    expiration_time = socket.assigns.expiration_time
    {:noreply, assign(socket, :time_remaining, time_remaining(expiration_time))}
  end

  @spec handle_event(event :: binary, LV.unsigned_params(), Socket.t()) ::
          {:noreply, Socket.t()}
  def handle_event("update", %{"seats" => seats}, socket) do
    seats = String.to_integer(seats)
    socket = assign(socket, seats: seats, amount: Licenses.calculate(seats))
    {:noreply, socket}
  end

  ## Private functions

  @spec time_remaining(DateTime.t()) :: pos_integer
  defp time_remaining(expiration_time) do
    DateTime.diff(expiration_time, Timex.now())
  end
end
