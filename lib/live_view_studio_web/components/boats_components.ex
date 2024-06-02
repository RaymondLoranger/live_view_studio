defmodule LiveView.StudioWeb.BoatsComponents do
  use LiveView.StudioWeb, [:html, :imports, :aliases]

  attr :header, :string, required: true
  attr :id, :string, required: true
  slot :inner_block, required: true

  @spec boats(Socket.assigns()) :: Rendered.t()
  def boats(assigns) do
    ~H"""
    <.header inner_class="text-center text-cool-gray-900 font-extrabold text-4xl mb-8">
      <%= @header %>
    </.header>

    <div id={@id}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  attr :id, :string, required: true
  attr :change, :string, required: true
  slot :inner_block, required: true

  def filter_form(assigns) do
    ~H"""
    <form id={@id} phx-change={@change} class="mx-auto mb-4 max-w-xl">
      <div class="flex flex-col items-center gap-5 sm:flex-row sm:justify-around">
        <%= render_slot(@inner_block) %>
      </div>
    </form>
    """
  end

  attr :type, :string, required: true

  def select_type(assigns) do
    ~H"""
    <select
      name="type"
      class={[
        "w-36 cursor-pointer rounded-lg px-4 py-2.5 text-base font-semibold leading-tight",
        "bg-cool-gray-200 border-cool-gray-400 text-cool-gray-700"
      ]}
    >
      <%= options_for_select(
        [
          "All Types": "",
          Fishing: "fishing",
          Sporting: "sporting",
          Sailing: "sailing"
        ],
        @type
      ) %>
    </select>
    """
  end

  attr :prices, :list, required: true

  def check_prices(assigns) do
    ~H"""
    <div class="flex">
      <%!-- To ensure 'prices' sent even when none selected. --%>
      <input type="hidden" name="prices[]" value="" />
      <%!-- The below class allows the prices to be tabbable. --%>
      <fieldset
        :for={price <- ["$", "$$", "$$$", "$$$$", "$$$$$"]}
        class="focus-within:mix-blend-multiply"
      >
        <%!-- 'checked' removed when @checked is false --%>
        <input
          type="checkbox"
          id={price}
          name="prices[]"
          value={price}
          checked={price in @prices}
          class="peer fixed w-0 opacity-0"
        />
        <label
          for={price}
          c1={price == "$"}
          c2={price == "$$"}
          c3={price == "$$$"}
          c4={price == "$$$$"}
          c5={price == "$$$$$"}
          class={[
            "inline-block cursor-pointer border-y px-4 py-3 text-base font-semibold leading-5",
            "border-cool-gray-400 bg-cool-gray-300",
            "hover:bg-cool-gray-400",
            "peer-checked:bg-indigo-300",
            "c1:rounded-l-lg c1:border-r c1:border-l",
            "c3:border-l",
            "c4:border-l",
            "c5:rounded-r-lg c5:border-r c5:border-l"
          ]}
        >
          <%= price %>
        </label>
      </fieldset>
    </div>
    """
  end

  attr :click, :string, required: true

  def clear_button(assigns) do
    ~H"""
    <a
      href="#"
      phx-click={@click}
      class="rounded-md px-2 py-1 text-base underline hover:bg-cool-gray-400 sm:py-2"
    >
      Clear All
    </a>
    """
  end

  attr :id, :string, required: true
  attr :update, :string, required: true
  slot :inner_block, required: true

  def boats_found(assigns) do
    ~H"""
    <div id={@id} class="flex flex-wrap justify-center" phx-update={@update}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  attr :id, :string, required: true
  attr :boat, Boat, required: true

  def boat_found(assigns) do
    ~H"""
    <div
      id={@id}
      class="m-3 max-w-sm overflow-hidden rounded bg-white shadow-lg"
    >
      <img class="h-48 w-80" src={@boat.image} />
      <div class="px-6 py-4">
        <div class="text-cool-gray-900 pb-3 text-center text-xl font-bold">
          <%= @boat.model %>
        </div>

        <div class="mt-2 flex justify-between px-6">
          <span class="text-cool-gray-700 text-xl font-semibold">
            <%= @boat.price %>
          </span>
          <span class="bg-cool-gray-300 text-cool-gray-700 rounded-full px-3 py-1 text-sm font-semibold">
            <%= @boat.type %>
          </span>
        </div>
      </div>
    </div>
    """
  end
end
