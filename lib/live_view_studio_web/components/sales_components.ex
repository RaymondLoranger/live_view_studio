defmodule LiveView.StudioWeb.SalesComponents do
  use LiveView.StudioWeb, [:html, :imports, :aliases]

  attr :header, :string, required: true
  attr :id, :string, required: true
  slot :inner_block, required: true

  @spec sales(Socket.assigns()) :: Rendered.t()
  def sales(assigns) do
    ~H"""
    <.header inner_class="text-cool-gray-900 mb-10 text-center text-4xl font-extrabold leading-normal">
      <%= @header %>
    </.header>

    <div id={@id} class="mx-auto max-w-2xl">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  slot :inner_block, required: true

  def stats(assigns) do
    ~H"""
    <div
      id="stats"
      class={[
        "mb-8 grid grid-cols-3 justify-items-center rounded-lg shadow-lg",
        "bg-white",
        "dark:bg-cool-gray-600"
      ]}
    >
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  attr :id, :string, required: true
  attr :value, :string, required: true
  attr :label, :string, required: true

  def stat(assigns) do
    ~H"""
    <div class="px-4 py-6 text-center">
      <span
        id={@id}
        class={[
          "block text-xl font-extrabold leading-none sm:text-5xl",
          "text-indigo-600",
          "dark:text-indigo-300"
        ]}
      >
        <%= @value %>
      </span>
      <span
        id={"#{@id}-label"}
        class={[
          "mt-2 block text-base font-medium sm:text-lg",
          "text-cool-gray-500",
          "dark:text-cool-gray-200"
        ]}
      >
        <%= @label %>
      </span>
    </div>
    """
  end

  attr :id, :string, required: true
  slot :inner_block, required: true

  def controls(assigns) do
    ~H"""
    <div id={@id} class="flex items-center justify-end">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  attr :id, :string, required: true
  attr :change, :string, required: true
  slot :inner_block, required: true

  def refresh_form(assigns) do
    ~H"""
    <form id={@id} phx-change={@change} class="flex items-center">
      <%= render_slot(@inner_block) %>
    </form>
    """
  end

  attr :for, :string, required: true

  def refresh_label(assigns) do
    ~H"""
    <label
      for={@for}
      class="mr-2 text-xs font-semibold uppercase tracking-wide text-indigo-800"
    >
      Refresh every:
    </label>
    """
  end

  attr :name, :string, required: true
  attr :refresh_options, :list, required: true
  attr :refresh, :integer, required: true

  def refresh_select(assigns) do
    ~H"""
    <select
      name={@name}
      autofocus="true"
      class={[
        "mr-2 h-10 w-20 cursor-pointer rounded-lg border px-4 py-2 font-semibold leading-tight",
        "border-indigo-300 text-indigo-700",
        "bg-indigo-50 hover:ring-1 hover:ring-indigo-500 hover:border-indigo-500 hover:ring-offset-1 focus:border-indigo-500",
        "dark:bg-indigo-100 dark:hover:ring-1 dark:hover:ring-indigo-600 dark:hover:border-indigo-600 dark:hover:ring-offset-1 dark:focus:border-indigo-600"
      ]}
    >
      <%= options_for_select(@refresh_options, @refresh) %>
    </select>
    """
  end

  attr :click, :string, required: true

  def refresh_button(assigns) do
    ~H"""
    <button
      phx-click={@click}
      class={[
        "inline-flex items-center rounded-lg border px-4 py-2 text-sm font-medium leading-6 shadow-sm outline-none",
        "border-indigo-300 text-indigo-700",
        "bg-indigo-50 hover:ring-1 hover:ring-indigo-500 hover:border-indigo-500 hover:ring-offset-1 focus:border-indigo-500 focus:ring-1 focus:ring-indigo-500 active:bg-indigo-200",
        "dark:bg-indigo-100 dark:hover:ring-1 dark:hover:ring-indigo-600 dark:hover:border-indigo-600 dark:hover:ring-offset-1 dark:focus:border-indigo-600 dark:focus:ring-1 dark:focus:ring-indigo-600 dark:active:bg-indigo-200"
      ]}
    >
      <img class="mr-2 h-4 w-4" src="/images/refresh.svg" /> Refresh
    </button>
    """
  end

  attr :last_updated_at, :string, required: true

  def last_update(assigns) do
    ~H"""
    <p class="mt-2 text-right text-sm text-indigo-800">
      last updated at: <%= @last_updated_at %>
    </p>
    """
  end
end
