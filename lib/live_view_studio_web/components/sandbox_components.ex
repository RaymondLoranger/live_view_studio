defmodule LiveView.StudioWeb.SandboxComponents do
  use LiveView.StudioWeb, [:html, :imports, :aliases]

  @colors ~W[green-700 blue-800 indigo-600 purple-700 pink-600]
  @material_options [
    Sand: "sand",
    "Beach Sand": "beach sand",
    "Mason Sand": "mason sand",
    "River Sand": "river sand"
  ]
  @label_class [
    "block flex-1 pr-2 text-right text-base font-bold leading-5",
    "text-gray-700 dark:text-gray-200"
  ]
  @field_class [
    "form-input block w-full min-w-0 flex-1 rounded-md text-base leading-5",
    "transition duration-150 ease-in-out",
    "focus:border-indigo-300 focus:outline-none",
    "focus:ring focus:ring-indigo-300",
    "dark:bg-gray-200 dark:focus:border-orange-400 dark:focus:ring-orange-400"
  ]
  @unit_class "ml-2 flex-1 text-left text-gray-700 dark:text-gray-200"

  attr :header, :string, required: true
  attr :id, :string, required: true
  slot :inner_block, required: true

  @spec sandbox(Socket.assigns()) :: Rendered.t()
  def sandbox(assigns) do
    ~H"""
    <.header inner_class="text-center text-cool-gray-900 font-extrabold text-4xl mb-8">
      <%= @header %>
    </.header>

    <div id={@id} class="mx-auto mb-8 max-w-xl">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  attr :weight, :float, required: true
  attr :price, :float, required: true
  attr :fee, :float, required: true
  attr :material, :string, required: true
  attr :color, :any
  attr :hrs_until_expires, :any

  def sandbox_quote(assigns) do
    assigns =
      assigns
      |> assign_new(:color, fn -> Enum.random(@colors) end)
      |> assign_new(:hrs_until_expires, fn -> Enum.random(24..6//-6) end)

    ~H"""
    <div
      c1={@color == "green-700"}
      c2={@color == "blue-800"}
      c3={@color == "indigo-600"}
      c4={@color == "purple-700"}
      c5={@color == "pink-600"}
      class={[
        "border-4 border-dashed p-6 text-center",
        "c1:border-green-700",
        "c2:border-blue-800",
        "c3:border-indigo-600",
        "c4:border-purple-700",
        "c5:border-pink-600"
      ]}
    >
      <h2 class="mb-2 text-2xl">
        Our Best Deal:
      </h2>
      <div
        c1={@color == "green-700"}
        c2={@color == "blue-800"}
        c3={@color == "indigo-600"}
        c4={@color == "purple-700"}
        c5={@color == "pink-600"}
        class={[
          "c1:text-green-700",
          "c2:text-blue-800",
          "c3:text-indigo-600",
          "c4:text-purple-700",
          "c5:text-pink-600"
        ]}
      >
        <h3 class="text-xl font-semibold">
          <%= @weight %> pounds of
          <span class="font-bold">
            <%= @material %>
          </span>
          for <%= number_to_currency(@price) %>
        </h3>
        <h4 class="text-xl font-semibold">
          plus <%= number_to_currency(@fee) %> for delivery 🚚
        </h4>
      </div>
      <div class="text-gray-600">
        expires in <%= @hrs_until_expires %> hours
      </div>
    </div>
    """
  end

  attr :id, :string, required: true
  attr :target, Phoenix.LiveComponent.CID, required: true
  attr :change, :string, required: true
  attr :submit, :string, required: true
  slot :inner_block, required: true

  @spec sandbox_form(Socket.assigns()) :: Rendered.t()
  def sandbox_form(assigns) do
    ~H"""
    <form
      id={@id}
      phx-target={@target}
      phx-change={@change}
      phx-submit={@submit}
      phx-mounted={JS.focus_first()}
      class="mx-auto mb-6 rounded-md border border-gray-300 bg-white p-4 text-center shadow-lg dark:bg-gray-600"
    >
      <%= render_slot(@inner_block) %>
    </form>
    """
  end

  attr :id, :string, required: true
  attr :target, Phoenix.LiveComponent.CID, required: true
  attr :change, :string, required: true
  slot :inner_block, required: true

  @spec zip_form(Socket.assigns()) :: Rendered.t()
  def zip_form(assigns) do
    ~H"""
    <form
      id={@id}
      phx-target={@target}
      phx-change={@change}
      onKeyDown="return event.key != 'Enter';"
      class="mx-auto mb-6 rounded-md border border-gray-300 bg-white p-4 text-center shadow-lg dark:bg-gray-600"
    >
      <%= render_slot(@inner_block) %>
    </form>
    """
  end

  attr :name, :string, required: true
  attr :label, :string, required: true
  attr :value, :float, required: true
  attr :required, :boolean, default: true
  attr :placeholder, :string, required: true
  attr :unit, :string, required: true
  attr :min, :string, default: "1"
  attr :step, :string, default: "0.1"
  attr :label_class, :list, default: @label_class
  attr :field_class, :list, default: @field_class
  attr :unit_class, :string, default: @unit_class

  def dim_field(assigns) do
    ~H"""
    <div class="flex items-center p-2">
      <label for={@name} class={@label_class}>
        <%= @label %>
      </label>
      <input
        type="number"
        min={@min}
        step={@step}
        name={@name}
        value={@value}
        required={@required}
        placeholder={@placeholder}
        phx-debounce="250"
        class={@field_class}
      />
      <span class={@unit_class}>
        <%= @unit %>
      </span>
    </div>
    """
  end

  attr :name, :string, required: true
  attr :label, :string, required: true
  attr :value, :string, required: true
  attr :options, :list, default: @material_options
  attr :unit, :string, required: true
  attr :label_class, :list, default: @label_class
  attr :field_class, :list, default: @field_class
  attr :unit_class, :string, default: @unit_class

  def select_material(assigns) do
    ~H"""
    <div class="flex items-center p-2">
      <label for={@name} class={@label_class}>
        <%= @label %>
      </label>
      <select name={@name} class={@field_class}>
        <%= options_for_select(@options, @value) %>
      </select>
      <span class={@unit_class}>
        <%= @unit %>
      </span>
    </div>
    """
  end

  attr :weight, :float, required: true
  attr :material, :string, required: true

  def what_you_need(assigns) do
    ~H"""
    <div
      id="weight-calculated"
      class="mt-4 block text-base font-semibold leading-5 text-gray-700 dark:text-gray-200"
    >
      You need <%= @weight %> pounds of <%= @material %> 🏝
    </div>
    """
  end

  def calculate_quote_button(assigns) do
    ~H"""
    <button
      type="submit"
      class="mt-6 rounded-md border border-transparent bg-green-500 px-4 py-2 text-lg font-semibold text-white outline-none transition duration-150 ease-in-out hover:bg-green-600 focus:border-green-600 focus:outline-none focus:ring focus:ring-green-300"
    >
      Calculate Quote
    </button>
    """
  end
end
