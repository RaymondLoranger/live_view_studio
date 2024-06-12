defmodule LiveView.StudioWeb.DonationsLive do
  use LiveView.StudioWeb, [:live_view, :imports, :aliases]

  import DonationsComponents

  @spec mount(LV.unsigned_params(), map, Socket.t()) ::
          {:ok, Socket.t(), keyword}
  def mount(_params, _session, socket) do
    # Here donations: [] is ok as going beyond EOF should not update the UI...
    {:ok, assign(socket, page_title: "Donations", total: donations_count()),
     temporary_assigns: [donations: []]}
  end

  @spec handle_params(LV.unsigned_params(), String.t(), Socket.t()) ::
          {:noreply, Socket.t()}
  def handle_params(params, _uri, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @spec render(Socket.assigns()) :: Rendered.t()
  def render(assigns) do
    ~H"""
    <.focus_wrap id="donations-focus-wrap">
      <.donations
        id="donations"
        header={donations_header(@live_action)}
        subtitle="⇐ = previous, ⇒ = next"
      >
        <.live_component
          id="per-page-form"
          module={PerPageForm}
          options={@options}
          total={@total}
          route={route(@live_action)}
        />
        <.page_table_wrapper>
          <.page_table
            rows={@donations}
            route={route(@live_action)}
            options={@options}
          >
            <:col :let={donation} :if={@live_action == :sort} field={:id}>
              <.id donation={donation} />
            </:col>
            <:col :let={donation} field={:item}>
              <.item donation={donation} action={@live_action} />
            </:col>
            <:col :let={donation} field={:quantity}>
              <.quantity donation={donation} />
            </:col>
            <:col :let={donation} field={:days_until_expires}>
              <.days_until_expires donation={donation} />
            </:col>
          </.page_table>
          <.pagination
            options={@options}
            total={@total}
            route={route(@live_action)}
          />
        </.page_table_wrapper>
      </.donations>
    </.focus_wrap>
    """
  end

  ## Private functions

  @spec apply_action(Socket.t(), action :: atom, LV.unsigned_params()) ::
          Socket.t()
  defp apply_action(socket, :paginate, params) do
    paginate_options = paginate_options(params)
    donations = list_donations(paginate: paginate_options)
    assign(socket, options: paginate_options, donations: donations)
  end

  defp apply_action(socket, :sort, params) do
    paginate_options = paginate_options(params)
    sort_options = sort_options(params)
    donations = list_donations(paginate: paginate_options, sort: sort_options)
    options = Map.merge(paginate_options, sort_options)
    assign(socket, options: options, donations: donations)
  end

  @spec paginate_options(LV.unsigned_params()) :: map
  defp paginate_options(params) do
    page = String.to_integer(params["page"] || "1")
    per_page = String.to_integer(params["per_page"] || "5")
    %{page: page, per_page: per_page}
  end

  @spec sort_options(LV.unsigned_params()) :: map
  defp sort_options(params) do
    sort_by = String.to_atom(params["sort_by"] || "id")
    sort_order = String.to_atom(params["sort_order"] || "asc")
    %{sort_by: sort_by, sort_order: sort_order}
  end

  # options = %{page: 3, per_page: 10}
  # route(:paginate).(options) =>
  #   "/donations/paginate?page=3&per_page=10"

  # options = %{sort_by: :item, page: 1, per_page: 5, sort_order: :desc}
  # route(:sort).(options) =>
  #   "/donations/sort?sort_by=item&page=1&per_page=5&sort_order=desc"
  @spec route(action :: atom) :: (map -> Path.t())
  defp route(:paginate),
    do: fn options -> ~p"/donations/paginate?#{options}" end

  defp route(:sort), do: fn options -> ~p"/donations/sort?#{options}" end

  @spec donations_header(action :: atom) :: String.t()
  defp donations_header(:paginate), do: "Food Bank Donations"
  defp donations_header(:sort), do: "👆 Food Bank Donations 👇"
end
