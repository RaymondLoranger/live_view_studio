defmodule LiveView.StudioWeb.LicenseComponents do
  use LiveView.StudioWeb, [:html, :imports, :aliases]

  slot :inner_block, required: true

  @spec license(Socket.assigns()) :: Rendered.t()
  def license(assigns) do
    ~H"""
    <.header inner_class="text-center text-cool-gray-900 font-extrabold text-4xl mb-8">
      Team License
    </.header>

    <div id="license" class="mx-auto max-w-xl text-center">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  slot :inner_block, required: true

  def card(assigns) do
    ~H"""
    <div class="rounded-lg bg-white shadow-lg dark:bg-gray-800">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  slot :inner_block, required: true

  def content(assigns) do
    ~H"""
    <div class="p-6">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  attr :seats, :integer, required: true

  def seats(assigns) do
    ~H"""
    <div id="seats" class="mb-8 inline-flex items-center">
      <img class="w-11 pr-2 dark:brightness-200" src="/images/license.svg" />
      <span class="text-cool-gray-700 text-xl font-semibold dark:text-cool-gray-100">
        Your license is currently for <strong><%= @seats %></strong>
        <%= ngettext("seat", "seats", @seats) %>.
      </span>
    </div>
    """
  end

  attr :change, :string, required: true
  attr :seats, :integer, required: true

  def slider(assigns) do
    ~H"""
    <form id="update-seats" phx-change={@change}>
      <input
        class="w-full"
        type="range"
        min="1"
        max="10"
        name="seats"
        value={@seats}
        autofocus="true"
        phx-debounce="250"
      />
    </form>
    """
  end

  attr :amount, :float, required: true

  def amount(assigns) do
    ~H"""
    <div
      id="amount"
      class="text-cool-gray-900 mt-4 text-4xl font-extrabold leading-none dark:text-cool-gray-200"
    >
      <%= number_to_currency(@amount) %>
    </div>
    """
  end

  attr :time_remaining, :integer, required: true

  def timer(assigns) do
    ~H"""
    <p class="m-4 font-semibold text-indigo-600 dark:text-teal-100">
      <%= if @time_remaining > 0 do %>
        <span class="font-bold text-purple-700 dark:text-teal-300">
          <%= format_time(@time_remaining) %>
        </span>
        left to save 20%
      <% else %>
        Expired!
      <% end %>
    </p>
    """
  end

  ## Private functions

  @spec format_time(pos_integer) :: String.t()
  defp format_time(seconds) do
    Timex.Duration.from_seconds(seconds) |> Timex.format_duration(:humanized)
  end
end
