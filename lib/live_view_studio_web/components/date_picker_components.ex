defmodule LiveView.StudioWeb.DatePickerComponents do
  use LiveView.StudioWeb, [:html, :imports, :aliases]

  slot :inner_block, required: true
  slot :date_picked, required: true

  @spec date_picker(Socket.assigns()) :: Rendered.t()
  def date_picker(assigns) do
    ~H"""
    <div class="flex justify-center">
      <div class="flex flex-col">
        <%= render_slot(@inner_block) %>
        <%= render_slot(@date_picked) %>
      </div>
    </div>
    """
  end

  slot :inner_block, required: true

  def date_form(assigns) do
    ~H"""
    <form class="mt-4">
      <%= render_slot(@inner_block) %>
    </form>
    """
  end

  attr :date, :string, required: true
  attr :hook, :string, required: true

  def date_field(assigns) do
    ~H"""
    <input
      id="date-picker-input"
      type="text"
      class="form-input !text-xl"
      value={@date}
      placeholder="Pick a date"
      phx-hook={@hook}
    />
    """
  end

  attr :date, :string, required: true

  def date_picked(assigns) do
    ~H"""
    <p :if={@date} class="mt-8 text-xl">
      See you on <%= @date %>!
    </p>
    """
  end
end
