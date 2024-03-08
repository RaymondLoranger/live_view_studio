defmodule LiveView.StudioWeb.StoresComponents do
  use LiveView.StudioWeb, [:html, :aliases]

  attr :header, :string, required: true
  attr :id, :string, required: true
  slot :inner_block, required: true

  @spec stores(Socket.assigns()) :: Rendered.t()
  def stores(assigns) do
    ~H"""
    <.header inner_class="text-center text-cool-gray-900 font-extrabold text-4xl mb-8">
      <%= @header %>
    </.header>

    <div id={@id} class="mx-auto max-w-2xl text-center">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  attr :id, :string, required: true
  attr :change, :string, required: true
  attr :submit, :string, required: true
  slot :inner_block, required: true

  def zip_form(assigns) do
    ~H"""
    <form
      id={@id}
      phx-change={@change}
      phx-submit={@submit}
      class="mb-2 inline-flex h-10"
    >
      <%= render_slot(@inner_block) %>
    </form>
    """
  end

  attr :zip, :string, required: true
  attr :searching, :boolean, required: true
  attr :areas, :list, required: true

  def zip_field(assigns) do
    ~H"""
    <%!-- 'readonly' removed when @searching is false --%>
    <input
      id="zip"
      class="border-cool-gray-400 w-36 rounded-l-md border bg-white px-5 text-base focus:outline-none focus:ring-0"
      type="text"
      name="zip"
      value={@zip}
      readonly={@searching}
      placeholder="Zip Code"
      phx-mounted={JS.focus()}
      autocomplete="off"
      phx-debounce="250"
      list="zip-list"
    />
    <datalist id="zip-list">
      <%= for {zip, city} <- @areas do %>
        <option label={city} value={zip} />
      <% end %>
    </datalist>
    """
  end

  attr :id, :string, required: true
  attr :change, :string, required: true
  attr :submit, :string, required: true
  slot :inner_block, required: true

  def city_form(assigns) do
    ~H"""
    <form
      id={@id}
      phx-change={@change}
      phx-submit={@submit}
      class="inline-flex h-10"
    >
      <%= render_slot(@inner_block) %>
    </form>
    """
  end

  attr :city, :string, required: true
  attr :searching, :boolean, required: true
  attr :cities, :list, required: true

  def city_field(assigns) do
    ~H"""
    <%!-- 'readonly' removed when @searching is false --%>
    <input
      class="border-cool-gray-400 ml-4 w-72 rounded-l-md border bg-white px-5 text-base focus:outline-none focus:ring-0"
      type="text"
      name="city"
      value={@city}
      readonly={@searching}
      placeholder="City"
      autocomplete="off"
      phx-debounce="150"
      list="cities"
    />
    <datalist id="cities">
      <%= for city <- @cities do %>
        <option value={city} />
      <% end %>
    </datalist>
    """
  end

  attr :id, :string, required: true
  attr :update, :string, required: true
  slot :inner_block, required: true

  def stores_found(assigns) do
    ~H"""
    <div class="my-8 overflow-hidden rounded-md bg-white shadow">
      <ul id={@id} phx-update={@update}>
        <%= render_slot(@inner_block) %>
      </ul>
    </div>
    """
  end

  attr :id, :string, required: true
  slot :inner_block, required: true

  def store_found(assigns) do
    ~H"""
    <li
      id={@id}
      class="border-cool-gray-300 border-t px-6 py-4 hover:bg-indigo-100"
    >
      <%= render_slot(@inner_block) %>
    </li>
    """
  end

  attr :store, Store, required: true

  def store_first_line(assigns) do
    ~H"""
    <div class="flex items-center justify-between">
      <div class="truncate text-lg font-medium leading-5 text-indigo-600">
        <%= @store.name %>
      </div>
      <div class="ml-2 flex-shrink-0">
        <%= if @store.open do %>
          <span class="inline-flex items-center rounded-full bg-green-200 px-3 py-1 text-xs font-medium leading-5 text-green-800">
            Open
          </span>
        <% else %>
          <span class="inline-flex items-center rounded-full bg-red-200 px-3 py-1 text-xs font-medium leading-5 text-red-800">
            Closed
          </span>
        <% end %>
      </div>
    </div>
    """
  end

  attr :store, Store, required: true

  def store_second_line(assigns) do
    ~H"""
    <div class="mt-2 flex justify-between">
      <div class="text-cool-gray-600 mt-0 flex items-center text-base leading-5">
        <img class="mr-1 h-5 w-5 flex-shrink-0" src="/images/location.svg" />
        <%= @store.street %>
      </div>
      <div class="text-cool-gray-600 mt-0 flex items-center text-sm leading-5">
        <img class="mr-2 h-5 w-5 flex-shrink-0" src="/images/phone.svg" />
        <%= @store.phone_number %>
      </div>
    </div>
    """
  end
end
