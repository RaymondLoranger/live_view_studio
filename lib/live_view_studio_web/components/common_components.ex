defmodule LiveView.StudioWeb.CommonComponents do
  use Phoenix.Component
  use LiveView.StudioWeb, [:verified_routes, :imports, :aliases]

  @spec search_submit_button(Socket.assigns()) :: Rendered.t()
  def search_submit_button(assigns) do
    ~H"""
    <button
      type="submit"
      class="border-cool-gray-500 rounded-r-md border border-l-0 bg-transparent px-4 outline-none transition duration-150 ease-in-out hover:bg-cool-gray-300 focus:border-blue-600"
    >
      <img class="h-4 w-4" src="/images/search.svg" />
    </button>
    """
  end

  attr :visible, :boolean, required: true

  def search_in_progress(assigns) do
    # <div :if={@visible} class="loader">Searching...</div>
    ~H"""
    <div :if={@visible} class="relative my-10 flex justify-center">
      <div class="absolute h-12 w-12 rounded-full border-8 border-gray-300" />
      <div class="absolute h-12 w-12 animate-spin rounded-full border-8 border-indigo-400 border-t-transparent" />
    </div>
    """
  end

  slot :inner_block, required: true

  def page_table_wrapper(assigns) do
    ~H"""
    <div
      id="page-table-wrapper"
      class="border-cool-gray-300 mb-4 inline-block min-w-full overflow-hidden rounded-lg border-b align-middle shadow"
    >
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  attr :options, :map, required: true
  attr :route, :any, required: true, doc: "A function actually..."
  attr :rows, :list, required: true

  slot :col, required: true do
    attr :field, :atom
  end

  def page_table(assigns) do
    ~H"""
    <table class="min-w-full">
      <thead>
        <tr>
          <th
            :for={col <- @col}
            class="border-cool-gray-300 border-b bg-indigo-700 py-4 pr-6 pl-4 text-center text-base font-medium uppercase leading-4 tracking-wider text-white first:w-40 first:pr-2"
          >
            <.column_header
              options={@options}
              field={col.field}
              route={@route}
            />
          </th>
        </tr>
      </thead>

      <tbody class="bg-white">
        <tr
          :for={row <- @rows}
          id={"row-#{row.id}"}
          class="bg-indigo-50 hover:bg-indigo-100"
        >
          <%= for col <- @col do %>
            <td class="border-cool-gray-300 text-cool-gray-900 whitespace-nowrap border-b py-4 pr-6 pl-4 text-center text-lg font-medium leading-5 first:pl-10 first:text-left first:font-semibold">
              <%= render_slot(col, row) %>
            </td>
          <% end %>
        </tr>
      </tbody>
    </table>
    """
  end

  attr :options, :map, required: true
  attr :route, :any, required: true, doc: "A function actually..."
  attr :total, :integer, required: true

  def pagination(assigns) do
    ~H"""
    <div class="mx-auto max-w-6xl bg-indigo-50 py-8 text-center text-lg">
      <div class="inline-flex shadow-sm">
        <.previous_page_link
          :if={@options.page > 1}
          options={@options}
          route={@route}
        />
        <.page_link
          :for={page <- (@options.page - 2)..(@options.page + 2)}
          :if={page in 1..ceil(@total / @options.per_page)}
          options={@options}
          route={@route}
          page={page}
        />
        <.next_page_link
          :if={@options.page * @options.per_page < @total}
          options={@options}
          route={@route}
        />
      </div>
    </div>
    """
  end

  ## Private functions

  @spec column_header(Socket.assigns()) :: Rendered.t()
  defp column_header(
         %{
           field: field,
           options: %{sort_order: dir, sort_by: key} = options
         } = assigns
       ) do
    header = "#{humanize(field)}#{if field == key, do: emoji(dir)}"
    options = sort_by_and_toggle_order(options, field)
    assigns = assign(assigns, header: header, options: options)

    ~H"""
    <.link
      patch={@route.(@options)}
      class={[
        "px-2 font-semibold no-underline text-white hover:text-yellow-400",
        "focus:border-white focus:rounded-sm focus:border focus:outline-none"
      ]}
    >
      <%= @header %>
    </.link>
    """
  end

  defp column_header(%{field: field} = assigns) do
    assigns = assign(assigns, header: humanize(field))

    ~H"""
    <%= @header %>
    """
  end

  @spec previous_page_link(Socket.assigns()) :: Rendered.t()
  defp previous_page_link(assigns) do
    options = assigns.options
    assigns = assign(assigns, :options, update_in(options.page, &(&1 - 1)))

    ~H"""
    <.link
      patch={@route.(@options)}
      class={[
        "text-base font-medium items-center px-3 py-2 border border-l-0 border-cool-gray-400 leading-5 no-underline hover:bg-cool-gray-300",
        "bg-white text-indigo-700 rounded-l-md !border-l",
        "focus:bg-cool-gray-400 focus:outline-none"
      ]}
    >
      Previous
    </.link>
    """
  end

  @spec next_page_link(Socket.assigns()) :: Rendered.t()
  defp next_page_link(assigns) do
    options = assigns.options
    assigns = assign(assigns, :options, update_in(options.page, &(&1 + 1)))

    ~H"""
    <.link
      patch={@route.(@options)}
      class={[
        "text-base font-medium items-center px-3 py-2 border border-l-0 border-cool-gray-400 leading-5 no-underline hover:bg-cool-gray-300",
        "bg-white text-indigo-700 rounded-r-md",
        "focus:bg-cool-gray-400 focus:outline-none"
      ]}
    >
      Next
    </.link>
    """
  end

  @spec page_link(Socket.assigns()) :: Rendered.t()
  defp page_link(assigns) do
    options = assigns.options
    assigns = assign(assigns, current?: assigns.page == options.page)
    assigns = assign(assigns, options: put_in(options.page, assigns.page))

    ~H"""
    <.link
      patch={@route.(@options)}
      class={[
        "text-base font-medium items-center px-3 py-2 border border-l-0 border-cool-gray-400 leading-5 no-underline hover:bg-cool-gray-300",
        @current? && "bg-indigo-700 text-white hover:text-black",
        !@current? && "bg-cool-gray-100 text-cool-gray-900",
        "focus:bg-cool-gray-400 focus:outline-none"
      ]}
    >
      <%= @page %>
    </.link>
    """
  end

  @spec emoji(sort_order :: atom) :: String.t()
  defp emoji(:asc), do: "👆"
  defp emoji(:desc), do: "👇"

  @spec sort_by_and_toggle_order(map, field :: atom) :: map
  defp sort_by_and_toggle_order(%{sort_order: :asc} = options, field) do
    %{options | sort_by: field, sort_order: :desc}
  end

  defp sort_by_and_toggle_order(%{sort_order: :desc} = options, field) do
    %{options | sort_by: field, sort_order: :asc}
  end
end
