defmodule LiveView.StudioWeb.DatePickerLive do
  use LiveView.StudioWeb, [:live_view, :aliases]

  import DatePickerComponents

  @spec mount(LV.unsigned_params(), map, Socket.t()) :: {:ok, Socket.t()}
  def mount(_params, _session, socket) do
    {:ok, assign(socket, date: nil, page_title: "Date Picker")}
  end

  @spec render(Socket.assigns()) :: Rendered.t()
  def render(assigns) do
    ~H"""
    <.date_picker>
      <.date_form>
        <.date_field date={@date} hook="DatePicker" />
      </.date_form>
      <:date_picked>
        <.date_picked date={@date} />
      </:date_picked>
    </.date_picker>
    """
  end

  # New function to handle an event pushed from the DatePicker JS hook module.
  # The payload is always in the 2nd argument, which is here a date string map.
  @spec handle_event(event :: binary, LV.unsigned_params(), Socket.t()) ::
          {:noreply, Socket.t()}
  def handle_event("date-picked", %{"dateStr" => date} = _params, socket) do
    {:noreply, assign(socket, date: date)}
  end
end
