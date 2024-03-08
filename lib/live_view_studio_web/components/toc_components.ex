defmodule LiveView.StudioWeb.TOCComponents do
  use LiveView.StudioWeb, [:html, :imports, :aliases]
  use PersistConfig

  @namespace get_env(:namespace) |> inspect()
  # => "LiveView.Studio"

  slot :inner_block, required: true

  @spec welcome_section(Socket.assigns()) :: Rendered.t()
  def welcome_section(assigns) do
    ~H"""
    <section class="bg-cool-gray-400 mx-12 mt-0 mb-4 rounded-md px-4 py-8 text-center">
      <h1 class={[
        "mb-4 text-center text-4xl font-medium text-blue-900",
        "underline decoration-wavy hover:opacity-70"
      ]}>
        <%= gettext("Welcome to %{name}!", name: "Phoenix") %>
      </h1>
      <p class="mb-8 text-lg font-normal hover:opacity-70">
        Peace of mind from prototype to production
      </p>
      <%= render_slot(@inner_block) %>
    </section>
    """
  end

  attr :change, :string, required: true
  attr :submit, :string, required: true
  slot :inner_block, required: true

  def dep_search_form(assigns) do
    ~H"""
    <form
      id="dep-search"
      phx-change={@change}
      phx-submit={@submit}
      class="flex flex-row justify-center"
    >
      <%= render_slot(@inner_block) %>
    </form>
    """
  end

  attr :dep, :string, required: true
  attr :deps, :list, required: true

  def dep_field(assigns) do
    ~H"""
    <input
      id="dep"
      type="text"
      name="dep"
      value={@dep}
      class="mt-4 ml-12 h-10 w-2/3 rounded-l-lg border border-orange-600 bg-white text-base focus:outline-none focus:ring-0"
      phx-mounted={JS.focus()}
      autocomplete="off"
      phx-debounce="150"
      placeholder="Dependency Search"
      list="deps"
    />
    <datalist id="deps">
      <%= for {app, {desc, _vsn}} <- @deps do %>
        <option label={desc} value={app} />
      <% end %>
    </datalist>
    """
  end

  def go_button(assigns) do
    ~H"""
    <button
      type="submit"
      phx-disable-with="Going..."
      class="mt-4 mr-12 h-10 whitespace-nowrap rounded-r-lg bg-blue-600 px-2 text-sm font-medium uppercase text-white outline-none transition duration-150 ease-in-out hover:brightness-125 focus:bg-orange-600"
    >
      Go to Hexdocs
    </button>
    """
  end

  def toc_section(assigns) do
    ~H"""
    <section id="toc" class="mt-8 flex flex-col items-center gap-1">
      <h2 class={[
        "text-center text-3xl font-normal tracking-wider",
        "hover:opacity-70"
      ]}>
        Table of Contents
      </h2>
      <ul
        id="live_views"
        phx-update="replace"
        class={[
          "mt-2 -ml-6 list-none whitespace-nowrap sm:ml-12",
          "grid grid-cols-1 sm:grid-cols-2 sm:pl-12 md:grid-cols-3 md:pl-6"
        ]}
      >
        <li
          :for={{text, path} <- live_views()}
          class={[
            "mt-3 text-center no-underline sm:ml-6 sm:text-left",
            "hover:text-indigo-800 hover:brightness-150"
          ]}
        >
          <.link navigate={path}><%= text %></.link>
        </li>
      </ul>
    </section>
    """
  end

  ## Private functions

  @spec live_views :: [{text :: String.t(), path :: String.t()}]
  defp live_views do
    for %{path: path, metadata: metadata, plug: plug} <- Router.__routes__(),
        {module, action, _list, _map} =
          (if metadata[:phoenix_live_view] do
             metadata.phoenix_live_view
           else
             {plug, nil, [], %{}}
           end),
        module = inspect(module),
        String.starts_with?(module, @namespace),
        !String.contains?(path, ":") do
      # E.g. captures "GitRepos" in "LiveView.StudioWeb.GitReposLive".
      # Also captures "PageController" in "LiveView.StudioWeb.PageController".
      [_, camel_case, _] = Regex.run(~r/Web\.(.+?)(Live|)?$/, module)
      # E.g. {"Git Repos", "/git-repos"}...
      {text(camel_case) |> text(action), path}
    end
    |> Enum.uniq_by(fn {text, _path} -> text end)
    |> Enum.sort()
    |> Enum.map(fn {text, path} -> {prefix(path) <> text, path} end)
  end

  @spec text(String.t(), atom) :: String.t()
  # text("Underwater", nil) => "Underwater"
  defp text(text, _action = nil), do: text

  # text("Underwater", :show_modal) => "Underwater Show Modal"
  defp text(text, action) do
    "#{text} #{to_string(action) |> Macro.camelize() |> text()}"
  end

  @spec text(String.t()) :: String.t()
  defp text("TOC"), do: "Table of Contents"
  # "GitRepos" => "Git Repos"
  defp text(camel_case) when is_binary(camel_case) do
    # Insert a space before all noninitial capital letters...
    String.replace(camel_case, ~r/(\B[A-Z])/, " \\1")
  end

  defp prefix("/boats"), do: "🚤 "
  defp prefix("/bookings"), do: "📅 "
  defp prefix("/chart"), do: "📈 "
  defp prefix("/datepicker"), do: "📅 "
  defp prefix("/desks"), do: "🖥️ "
  defp prefix("/donations"), do: "🎁 "
  defp prefix("/donations/paginate"), do: "🎁 "
  defp prefix("/donations/sort"), do: "🎁 "
  defp prefix("/flights"), do: "✈️ "
  defp prefix("/git-repos"), do: "📚 "
  defp prefix("/home"), do: "🏠 "
  defp prefix("/juggling"), do: "🤹🏻‍♂️ "
  defp prefix("/license"), do: "🎫 "
  defp prefix("/light"), do: "💡 "
  defp prefix("/map"), do: "🗺️ "
  defp prefix("/pizzas"), do: "🍕 "
  defp prefix("/presence"), do: "👀 "
  defp prefix("/sales"), do: "📊 "
  defp prefix("/sales-home"), do: "📊 "
  defp prefix("/sandbox"), do: "🏝 "
  defp prefix("/servers"), do: "👨‍💻 "
  defp prefix("/servers/new/form"), do: "👨‍💻 "
  defp prefix("/servers/new/modal"), do: "👨‍💻 "
  defp prefix("/server-names"), do: "👨‍💻 "
  defp prefix("/stores"), do: "🏬 "
  defp prefix("/stores/autocomplete"), do: "🏬 "
  defp prefix("/shop"), do: "🛒 "
  defp prefix("/"), do: "📖 "
  defp prefix("/toc"), do: "📖 "
  defp prefix("/topsecret"), do: "🕵🏼 "
  defp prefix("/underwater"), do: "🐠 "
  defp prefix("/underwater/show"), do: "🐠 "
  defp prefix("/vehicles"), do: "🚗 "
  defp prefix("/volunteers"), do: "🙋‍♀️ "
  defp prefix(_), do: "❓ "
end
