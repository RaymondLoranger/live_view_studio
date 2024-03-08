defmodule LiveView.StudioWeb.GitReposComponents do
  use LiveView.StudioWeb, [:html, :imports, :aliases]

  attr :header, :string, required: true
  attr :id, :string, required: true
  slot :inner_block, required: true

  @spec repos(Socket.assigns()) :: Rendered.t()
  def repos(assigns) do
    ~H"""
    <.header inner_class="text-center text-cool-gray-900 font-extrabold text-4xl mb-8">
      <%= @header %>
    </.header>

    <div id={@id} class="mx-auto max-w-3xl text-center">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  attr :id, :string, required: true
  attr :change, :string, required: true
  slot :inner_block, required: true

  def filter_form(assigns) do
    ~H"""
    <form id={@id} phx-change={@change} class="inline-flex items-center px-2">
      <div class="flex flex-col items-center gap-2 sm:flex-row sm:items-baseline">
        <%= render_slot(@inner_block) %>
      </div>
    </form>
    """
  end

  attr :language, :string, required: true

  def select_language(assigns) do
    ~H"""
    <select
      name="language"
      autofocus="true"
      class="bg-cool-gray-200 border-cool-gray-400 text-cool-gray-700 mr-4 w-40 cursor-pointer appearance-none rounded-lg border px-4 py-3 font-semibold leading-tight"
    >
      <%= options_for_select(language_options(), @language) %>
    </select>
    """
  end

  attr :license, :string, required: true

  def select_license(assigns) do
    ~H"""
    <select
      name="license"
      class="bg-cool-gray-200 border-cool-gray-400 text-cool-gray-700 mr-4 w-36 cursor-pointer appearance-none rounded-lg border px-4 py-3 font-semibold leading-tight"
    >
      <%= options_for_select(license_options(), @license) %>
    </select>
    """
  end

  attr :click, :string, required: true

  def clear_button(assigns) do
    ~H"""
    <a
      href="#"
      phx-click={@click}
      class="inline whitespace-nowrap text-lg underline"
    >
      Clear All
    </a>
    """
  end

  attr :id, :string, required: true
  attr :update, :string, required: true
  slot :inner_block, required: true

  def repos_found(assigns) do
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

  def repo_found(assigns) do
    ~H"""
    <li
      id={@id}
      class="border-cool-gray-300 border-t px-6 py-4 hover:bg-indigo-100"
    >
      <%= render_slot(@inner_block) %>
    </li>
    """
  end

  attr :repo, GitRepo, required: true

  def repo_first_line(assigns) do
    ~H"""
    <div class="flex items-center justify-between">
      <div class="truncate whitespace-nowrap text-lg font-medium text-gray-800">
        <img class="mr-1 inline h-6 w-6" src="/images/terminal.svg" />
        <a href={@repo.owner_url} class="mr-1 inline-block text-lg underline">
          <%= @repo.owner_login %>
        </a>
        /
        <a href={@repo.url} class="inline-block text-lg underline">
          <%= @repo.name %>
        </a>
      </div>

      <button class="border-cool-gray-300 ml-2 flex items-center rounded border bg-transparent px-3 py-1 text-base font-medium shadow-sm outline-none hover:bg-cool-gray-300 hover:border-cool-gray-400 hover:border">
        <img class="mr-1 inline h-4 w-4" src="/images/star.svg" /> Star
      </button>
    </div>
    """
  end

  attr :repo, GitRepo, required: true

  def repo_second_line(assigns) do
    ~H"""
    <div class="mt-3 flex items-center justify-between">
      <div class="mt-0 flex items-center">
        <span class={class(@repo.language)}>
          <%= @repo.language %>
        </span>

        <span class="mr-4 ml-4 text-sm font-medium text-gray-600">
          <%= @repo.license %>
        </span>

        <%= if @repo.fork do %>
          <img class="inline h-4 w-4" src="/images/fork.svg" />
        <% end %>
      </div>

      <div class="mr-1">
        <%= @repo.stars %> stars
      </div>
    </div>
    """
  end

  ## Private functions

  defp class("elixir") do
    # class="bg-purple-300"
    [basic_class(), "bg-purple-300"]
  end

  defp class("ruby") do
    # class="bg-red-300"
    [basic_class(), "bg-red-300"]
  end

  defp class("js") do
    # class="bg-yellow-300"
    [basic_class(), "bg-yellow-300"]
  end

  defp class("perl") do
    # class="bg-cyan-300"
    [basic_class(), "bg-cyan-300"]
  end

  defp class("python") do
    # class="bg-teal-300"
    [basic_class(), "bg-teal-300"]
  end

  defp class(_) do
    # class="bg-neutral-300"
    [basic_class(), "bg-neutral-300"]
  end

  defp basic_class do
    # class="px-3 py-1 rounded-full font-medium text-sm text-gray-600"
    "px-3 py-1 rounded-full font-medium text-sm text-gray-600"
  end

  defp language_options do
    [
      "All Languages": "",
      "Elixir": "elixir",
      Ruby: "ruby",
      JavaScript: "js",
      Perl: "perl",
      Python: "python"
    ]
  end

  defp license_options do
    [
      "All Licenses": "",
      MIT: "mit",
      Apache: "apache",
      BSDL: "bsdl"
    ]
  end
end
