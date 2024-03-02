defmodule LiveView.StudioWeb.FlightsComponents do
  use LiveView.StudioWeb, [:html, :aliases]

  attr :header, :string, required: true
  attr :id, :string, required: true
  slot :inner_block, required: true
  slot :search_results, required: true

  @spec flights(Socket.assigns()) :: Rendered.t()
  def flights(assigns) do
    ~H"""
    <.header inner_class="text-center text-cool-gray-900 font-extrabold text-4xl mb-8">
      <%= @header %>
    </.header>

    <div id={@id}>
      <div
        id="forms"
        class="flex flex-col items-center gap-5 sm:flex-row sm:justify-center sm:gap-10"
      >
        <%= render_slot(@inner_block) %>
      </div>
      <%= render_slot(@search_results) %>
    </div>
    """
  end

  attr :change, :string, required: true
  attr :submit, :string, required: true
  slot :inner_block, required: true

  def flight_number_form(assigns) do
    ~H"""
    <form
      id="flight-number-form"
      phx-change={@change}
      phx-submit={@submit}
      class="inline-flex h-10"
    >
      <%= render_slot(@inner_block) %>
    </form>
    """
  end

  attr :number, :string, required: true
  attr :searching, :boolean, required: true
  attr :routes, :list, required: true

  def flight_number_field(assigns) do
    ~H"""
    <%!-- 'readonly' removed when @searching is false --%>
    <input
      id="flight-number-field"
      type="text"
      name="number"
      value={@number}
      readonly={@searching}
      placeholder="Flight Number"
      autocomplete="off"
      phx-mounted={JS.focus()}
      phx-debounce="250"
      list="routes"
      class="border-cool-gray-400 w-44 rounded-l-md border bg-white px-5 text-base focus:outline-none focus:ring-0"
    />
    <datalist id="routes">
      <option
        :for={{number, origin, destination} <- @routes}
        label={"#{origin}-#{destination}"}
        value={number}
      />
    </datalist>
    """
  end

  attr :change, :string, required: true
  attr :submit, :string, required: true
  slot :inner_block, required: true

  def airport_code_form(assigns) do
    ~H"""
    <form
      id="airport-code-form"
      phx-change={@change}
      phx-submit={@submit}
      class="inline-flex h-10"
    >
      <%= render_slot(@inner_block) %>
    </form>
    """
  end

  attr :code, :string, required: true
  attr :searching, :boolean, required: true
  attr :airports, :list, required: true

  def airport_code_field(assigns) do
    ~H"""
    <%!-- 'readonly' removed when @searching is false --%>
    <input
      id="airport-code-field"
      type="text"
      name="code"
      value={@code}
      readonly={@searching}
      placeholder="Airport Code"
      autocomplete="off"
      phx-debounce="150"
      list="airports"
      class="border-cool-gray-400 w-44 rounded-l-md border bg-white px-5 text-base focus:outline-none focus:ring-0"
    />
    <datalist id="airports">
      <option :for={{code, city} <- @airports} label={city} value={code} />
    </datalist>
    """
  end

  attr :id, :string, required: true
  attr :update, :string, required: true
  slot :inner_block, required: true

  def flights_found(assigns) do
    ~H"""
    <div class="mx-auto my-8 max-w-2xl overflow-hidden rounded-md bg-white shadow">
      <ul id={@id} phx-update={@update}>
        <%= render_slot(@inner_block) %>
      </ul>
    </div>
    """
  end

  attr :id, :string, required: true
  attr :flight, Flight, required: true

  def flight_found(assigns) do
    ~H"""
    <li
      id={@id}
      class="border-cool-gray-300 border-t px-6 py-4 hover:bg-indigo-100"
    >
      <%!-- First line --%>
      <div class="flex items-center justify-between">
        <div class="truncate text-lg font-semibold leading-5 text-indigo-600">
          Flight #<%= @flight.number %>
        </div>
        <div class="justify-right mt-0 flex items-center text-right text-base leading-5 text-indigo-600">
          <img class="h-5 w-5 flex-shrink-0" src="/images/location.svg" />
          <span><%= @flight.origin %> to <%= @flight.destination %></span>
        </div>
      </div>

      <%!-- Second line --%>
      <div class="mt-2 flex justify-between">
        <div class="text-cool-gray-500">
          Departs: <%= format_time(@flight.departure_time) %>
        </div>
        <div class="text-cool-gray-500 text-right">
          Arrives: <%= format_time(@flight.arrival_time) %>
        </div>
      </div>
    </li>
    """
  end

  ## Private functions

  @spec format_time(DateTime.t()) :: String.t()
  defp format_time(time) do
    Timex.format!(time, "%b %d at %H:%M", :strftime)
  end
end
