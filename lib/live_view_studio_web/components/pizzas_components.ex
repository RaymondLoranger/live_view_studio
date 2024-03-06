defmodule LiveView.StudioWeb.PizzasComponents do
  use LiveView.StudioWeb, [:html, :aliases]

  attr :header, :string, required: true
  attr :id, :string, required: true
  attr :update, :string, required: true
  slot :inner_block, required: true
  slot :footer, required: true

  @spec orders(Socket.assigns()) :: Rendered.t()
  def orders(assigns) do
    ~H"""
    <.header
      class="fixed left-0 top-12 p-3 bg-cool-gray-200 w-full"
      inner_class="text-center text-cool-gray-900 font-extrabold text-4xl m-4 whitespace-nowrap truncate"
    >
      <%= @header %>
    </.header>

    <div id={@id} phx-update={@update} class="mt-20">
      <%= render_slot(@inner_block) %>
    </div>

    <%= render_slot(@footer) %>
    """
  end

  attr :id, :string, required: true
  slot :inner_block, required: true

  def order(assigns) do
    ~H"""
    <div
      id={@id}
      class="text-cool-gray-700 m-6 mx-auto flex max-w-2xl items-center overflow-hidden rounded bg-white px-6 py-4 shadow-lg hover:bg-indigo-100"
    >
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  attr :order, PizzaOrder, required: true

  def id(assigns) do
    ~H"""
    <span class="bg-cool-gray-300 text-cool-gray-800 mr-4 inline-flex rounded-full px-4 py-3 text-base font-medium leading-4">
      <%= @order.id %>
    </span>
    """
  end

  attr :order, PizzaOrder, required: true

  def pizza(assigns) do
    ~H"""
    <span class="font-bold">
      <%= @order.pizza %>
    </span>
    """
  end

  attr :order, PizzaOrder, required: true

  def username(assigns) do
    ~H"""
    <div>
      ordered by
      <span class="text-cool-gray-900 underline">
        <%= @order.username %>
      </span>
    </div>
    """
  end

  attr :no_more, :boolean, required: true
  attr :id, :string, required: true
  attr :hook, :string, required: true

  def footer(assigns) do
    # The hook pushes event "load-more" when footer becomes visible.
    ~H"""
    <div
      no-more={@no_more}
      id={@id}
      phx-hook={@hook}
      class="mt-10 mb-20 text-center text-lg text-indigo-700 no-more:hidden"
    >
      <div class="loader">Loading More...</div>
    </div>
    """
  end
end
