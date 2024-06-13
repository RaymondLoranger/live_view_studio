defmodule LiveView.StudioWeb.DonationsComponents do
  use LiveView.StudioWeb, [:html, :imports, :aliases]

  attr :header, :string, required: true
  attr :subtitle, :string, required: true
  attr :id, :string, required: true
  slot :inner_block, required: true

  @spec donations(Socket.assigns()) :: Rendered.t()
  def donations(assigns) do
    ~H"""
    <.header
      inner_class="text-center text-cool-gray-900 font-extrabold text-4xl mb-8"
      subtitle_class="text-lg font-medium text-cool-gray-700 text-center mb-2"
    >
      <%= @header %>
      <:subtitle>
        <%= @subtitle %>
      </:subtitle>
    </.header>

    <section id={@id} class="mx-auto max-w-4xl">
      <%= render_slot(@inner_block) %>
    </section>
    """
  end

  attr :donation, Donation, required: true

  def id(assigns) do
    ~H"""
    <span class="text-cool-gray-400 mr-4 ml-8 text-base">
      <%= @donation.id %>
    </span>
    """
  end

  attr :action, :atom, required: true
  attr :donation, Donation, required: true

  def item(assigns) do
    ~H"""
    <.id :if={@action == :paginate} donation={@donation} />
    <%= @donation.emoji %>
    <%= @donation.item %>
    """
  end

  attr :donation, Donation, required: true

  def quantity(assigns) do
    ~H"""
    <%= @donation.quantity %> lbs
    """
  end

  attr :donation, Donation, required: true

  def days_until_expires(assigns) do
    ~H"""
    <span
      stale={almost_expired?(@donation)}
      fresh={!almost_expired?(@donation)}
      class={[
        "rounded-full px-4 py-2 text-lg font-medium leading-5",
        "stale:bg-red-200 stale:text-red-800",
        "fresh:bg-green-200 fresh:text-green-700"
      ]}
    >
      <%= @donation.days_until_expires %>
    </span>
    """
  end
end
