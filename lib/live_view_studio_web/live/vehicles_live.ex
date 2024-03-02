defmodule LiveView.StudioWeb.VehiclesLive do
  use LiveView.StudioWeb, [:live_view, :imports, :aliases]

  import VehiclesComponents

  @spec mount(LV.unsigned_params(), map, Socket.t()) ::
          {:ok, Socket.t(), keyword}
  def mount(_params, _session, socket) do
    # Here vehicles: [] is ok as going beyond EOF should not update the UI...
    {:ok, assign(socket, page_title: "Vehicles", total: vehicles_count()),
     temporary_assigns: [vehicles: []]}
  end

  @spec handle_params(LV.unsigned_params(), String.t(), Socket.t()) ::
          {:noreply, Socket.t()}
  def handle_params(params, _url, socket) do
    page = String.to_integer(params["page"] || "1")
    per_page = String.to_integer(params["per_page"] || "5")
    paginate_options = %{page: page, per_page: per_page}

    sort_by = String.to_atom(params["sort_by"] || "id")
    sort_order = String.to_atom(params["sort_order"] || "asc")
    sort_options = %{sort_by: sort_by, sort_order: sort_order}

    vehicles = list_vehicles(paginate: paginate_options, sort: sort_options)
    options = Map.merge(paginate_options, sort_options)
    {:noreply, assign(socket, options: options, vehicles: vehicles)}
  end

  @spec render(Socket.assigns()) :: Rendered.t()
  def render(assigns) do
    ~H"""
    <.focus_wrap id="vehicles-focus-wrap">
      <.vehicles
        id="vehicles"
        header="🚛🚙 Vehicles 🚘🚖"
        subtitle="⇐ = previous, ⇒ = next"
      >
        <.live_component
          id="per-page-form"
          module={PerPageForm}
          options={@options}
          total={@total}
          route={route()}
        />
        <.page_table_wrapper>
          <.page_table rows={@vehicles} route={route()} options={@options}>
            <:col :let={vehicle} field={:id}>
              <.id vehicle={vehicle} />
            </:col>
            <:col :let={vehicle} field={:make}>
              <.make vehicle={vehicle} />
            </:col>
            <:col :let={vehicle} field={:model}>
              <.model vehicle={vehicle} />
            </:col>
            <:col :let={vehicle} field={:color}>
              <.color vehicle={vehicle} />
            </:col>
          </.page_table>
          <.pagination options={@options} total={@total} route={route()} />
        </.page_table_wrapper>
      </.vehicles>
    </.focus_wrap>
    """
  end

  ## Private functions

  @spec route :: (map -> Path.t())
  defp route, do: fn options -> ~p"/vehicles?#{options}" end
end
