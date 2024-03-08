defmodule LiveView.StudioWeb.UnderwaterLive do
  use LiveView.StudioWeb, [:live_view, :aliases]

  import UnderwaterComponents

  @spec mount(LV.unsigned_params(), map, Socket.t()) :: {:ok, Socket.t()}
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @spec handle_params(LV.unsigned_params(), String.t(), Socket.t()) ::
          {:noreply, Socket.t()}
  def handle_params(_params, _uri, socket) do
    {:noreply, assign(socket, :page_title, title(socket.assigns.live_action))}
  end

  @spec render(Socket.assigns()) :: Rendered.t()
  def render(assigns) do
    ~H"""
    <.underwater id="underwater" header="Earth Is Super Watery">
      <.sea_button
        to={~p"/underwater/show"}
        mounted={JS.focus()}
        text="🤿⚓ Look Underwater 👀🥽"
      />

      <.modal
        :if={@live_action == :show_modal}
        id="underwater-modal"
        show={true}
        on_cancel={JS.patch(~p"/underwater")}
        outer_class="bg-white/10"
        inner_class="-mt-[21rem] mx-auto bg-science-blue/40 min-w-max max-w-xl
          border border-science-blue-dark"
      >
        <.sea_creatures>
          <.sea_button
            to={~p"/underwater"}
            text="😤 I'm outta air! 😮‍💨"
          />
        </.sea_creatures>
      </.modal>
    </.underwater>
    """
  end

  ## Private functions

  @spec title(action :: atom) :: String.t()
  defp title(nil), do: "Underwater"
  defp title(:show_modal), do: "Sea Creatures"
end
