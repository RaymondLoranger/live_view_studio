defmodule LiveView.StudioWeb.VehiclesComponents do
  use LiveView.StudioWeb, [:html, :aliases]

  attr :header, :string, required: true
  attr :subtitle, :string, required: true
  attr :id, :string, required: true
  slot :inner_block, required: true

  @spec vehicles(Socket.assigns()) :: Rendered.t()
  def vehicles(assigns) do
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

    <div id={@id} class="mx-auto max-w-4xl">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  attr :vehicle, Vehicle, required: true

  def id(assigns) do
    ~H"""
    <span class="text-cool-gray-400 mr-4 ml-8 text-base">
      <%= @vehicle.id %>
    </span>
    """
  end

  attr :vehicle, Vehicle, required: true

  def make(assigns) do
    ~H"""
    <span class={text_color(@vehicle.color)}>
      <%= @vehicle.make %>
    </span>
    """
  end

  attr :vehicle, Vehicle, required: true

  def model(assigns) do
    ~H"""
    <span class={text_color(@vehicle.color)}>
      <%= @vehicle.model %>
    </span>
    """
  end

  attr :vehicle, Vehicle, required: true

  def color(assigns) do
    ~H"""
    <span class={text_color(@vehicle.color)}>
      <%= @vehicle.color %>
    </span>
    """
  end

  ## Private functions

  defp text_color("Blue"), do: "text-blue-500"
  defp text_color("Brown"), do: "text-amber-800"
  defp text_color("Green"), do: "text-green-500"
  defp text_color("Orange"), do: "text-orange-500"
  defp text_color("Pink"), do: "text-pink-500"
  defp text_color("Purple"), do: "text-purple-500"
  defp text_color("Red"), do: "text-red-500"
  defp text_color("Yellow"), do: "text-yellow-500"
  defp text_color(_), do: nil
end
