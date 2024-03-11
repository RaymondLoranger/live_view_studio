defmodule LiveView.StudioWeb.IncidentsLive do
  use LiveView.StudioWeb, [:live_view, :aliases]

  import IncidentsComponents

  @spec mount(LV.unsigned_params(), map, Socket.t()) :: {:ok, Socket.t()}
  def mount(_params, _session, socket) do
    if connected?(socket), do: Incidents.subscribe()
    incidents = Incidents.list_incidents()
    # json_data = Jason.encode!(incidents)

    {:ok,
     assign(socket,
       page_title: "Mapped Incidents",
       incidents: incidents,
       # json_data: json_data,
       selected_incident: nil
     )}
  end

  @spec render(Socket.assigns()) :: Rendered.t()
  def render(assigns) do
    ~H"""
    <.mapping>
      <.incidents :let={incident} incidents={@incidents} update="replace">
        <.incident
          click="select-incident"
          incident={incident}
          selected={incident == @selected_incident}
        />
      </.incidents>

      <.map_view>
        <.map_wrapper update="ignore">
          <.map hook="IncidentMap" />
        </.map_wrapper>

        <.button_wrapper>
          <.map_button click="report-incident" />
        </.button_wrapper>
      </.map_view>
    </.mapping>
    """
  end

  @spec handle_event(event :: binary, LV.unsigned_params(), Socket.t()) ::
          {:noreply, Socket.t()}
  def handle_event("select-incident", %{"id" => id}, socket) do
    incident = find_incident(socket, String.to_integer(id))

    {:noreply,
     socket
     |> assign(selected_incident: incident)
     |> push_event("highlight-marker", incident)}
  end

  def handle_event("get-incidents", _params, socket) do
    {:reply, %{incidents: socket.assigns.incidents}, socket}
  end

  def handle_event("report-incident", _params, socket) do
    Incidents.create_random_incident()
    {:noreply, socket}
  end

  def handle_event("marker-clicked", incident_id, socket) do
    incident = find_incident(socket, incident_id)
    {:reply, %{incident: incident}, assign(socket, selected_incident: incident)}
  end

  @spec handle_info(msg :: term, Socket.t()) :: {:noreply, Socket.t()}
  def handle_info({Incidents, :incident_created, incident}, socket) do
    {:noreply,
     socket
     |> update(:incidents, &[incident | &1])
     |> assign(selected_incident: incident)
     |> push_event("add-marker", incident)}
  end

  ## Private functions

  @spec find_incident(Socket.t(), pos_integer) :: %Incident{}
  defp find_incident(socket, id) do
    Enum.find(socket.assigns.incidents, &(&1.id == id))
  end
end
