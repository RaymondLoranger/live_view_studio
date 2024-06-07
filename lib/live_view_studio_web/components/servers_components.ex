defmodule LiveView.StudioWeb.ServersComponents do
  use LiveView.StudioWeb, [:html, :aliases]

  attr :header, :string, required: true
  attr :id, :string, required: true
  slot :inner_block, required: true

  @spec servers(Socket.assigns()) :: Rendered.t()
  def servers(assigns) do
    ~H"""
    <.header inner_class="text-center text-cool-gray-900 font-extrabold text-4xl mb-12">
      <%= @header %>
    </.header>

    <div id={@id} class="mx-auto flex max-w-4xl justify-center gap-5">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  attr :id, :string, required: true
  attr :mounted, JS, required: true
  slot :add_server
  slot :inner_block, required: true

  def sidebar(assigns) do
    ~H"""
    <div
      id={@id}
      phx-mounted={@mounted}
      class="w-52 rounded-lg bg-indigo-800 px-3 py-4"
    >
      <%= render_slot(@add_server) %>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  attr :patch, :string, required: true
  attr :label, :string, required: true

  def add_server_link(assigns) do
    ~H"""
    <.link
      patch={@patch}
      class="p-3 mb-3 font-medium block rounded-md text-white text-sm leading-5 hover:scale-105 bg-indigo-600 outline-none focus:ring-1 focus:ring-indigo-100"
    >
      <%= @label %>
    </.link>
    """
  end

  attr :id, :string, required: true
  attr :update, :string, required: true
  attr :hook, :string, required: true
  slot :inner_block, required: true

  def navbar(assigns) do
    ~H"""
    <nav id={@id} phx-update={@update} phx-hook={@hook}>
      <%= render_slot(@inner_block) %>
    </nav>
    """
  end

  attr :id, :string, required: true
  attr :server, Server, required: true
  attr :selected_server, Server, required: true
  attr :patch, :string, required: true

  def server_link(assigns) do
    ~H"""
    <div
      id={@id}
      selected={@server == @selected_server}
      class="mb-1.5 rounded-md text-sm font-medium leading-5 text-indigo-300 selected:bg-indigo-600 selected:text-white hover:selected:scale-105"
    >
      <.link
        patch={@patch}
        class="rounded-md flex items-center gap-2 px-2 py-3 outline-none focus:ring-1 focus:ring-indigo-100 hover:bg-indigo-950 hover:text-white"
      >
        <span
          up={@server.status == "up"}
          down={@server.status == "down"}
          class="h-4 w-4 shrink-0 rounded-full down:bg-red-400 up:bg-green-400"
        />
        <img class="h-6 w-6" src="/images/server.svg" />
        <span class="truncate text-ellipsis" title={@server.name}>
          <%= @server.name %>
        </span>
      </.link>
    </div>
    """
  end

  slot :inner_block, required: true

  def main(assigns) do
    ~H"""
    <%!-- <div class="scrollbar-thumb-rounded-lg scrollbar-track-rounded-lg scrollbar scrollbar-thumb-indigo-500 scrollbar-track-indigo-200 scrollbar-corner-indigo-200 max-w-2xl overflow-auto rounded-lg bg-white shadow-md"> --%>
    <div class="max-w-2xl overflow-auto rounded-lg bg-white shadow-md flex-1">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  attr :id, :string, required: true
  slot :inner_block, required: true

  def server_layout(assigns) do
    ~H"""
    <div id={@id} class="group relative">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  attr :id, :string, required: true
  slot :inner_block, required: true

  def server_header(assigns) do
    ~H"""
    <div
      id={@id}
      class="flex items-center justify-between border-b border-gray-200 p-5"
    >
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  attr :id, :string, required: true
  attr :name, :string, required: true

  def server_name(assigns) do
    ~H"""
    <h2 id={@id} class="text-xl font-semibold leading-6 text-indigo-800">
      <%= @name %>
    </h2>
    """
  end

  attr :status, :string, required: true
  attr :click, :string, required: true
  attr :id, :string, required: true
  attr :disable_with, :string, required: true
  attr :target, Phoenix.LiveComponent.CID, required: true

  def toggle_button(assigns) do
    ~H"""
    <button
      up={@status == "up"}
      down={@status == "down"}
      phx-click={@click}
      phx-value-id={@id}
      phx-disable-with={@disable_with}
      phx-target={@target}
      class="rounded-full bg-red-200 px-3 py-1 text-xs font-medium leading-5 down:bg-red-200 down:text-red-800 up:bg-green-200 up:text-green-800 hover:scale-105"
    >
      <%= @status %>
    </button>
    """
  end

  attr :click, :string, required: true
  attr :id, :string, required: true
  attr :target, Phoenix.LiveComponent.CID, required: true

  def delete_icon(assigns) do
    ~H"""
    <.link
      phx-click={@click}
      phx-value-id={@id}
      phx-target={@target}
      title="Delete"
      class="absolute top-1 right-1 hidden cursor-pointer text-sm group-hover:block"
    >
      <.icon name="hero-trash-solid" class="w-4 h-4 text-slate-400" />
    </.link>
    """
  end

  attr :id, :string, required: true
  attr :server, Server, required: true

  def server_body(assigns) do
    ~H"""
    <div id={@id} class="h-72 px-8 py-4">
      <%!-- Server details --%>
      <section
        id="server-details"
        class="flex flex-wrap content-center items-baseline justify-between gap-3 p-2 text-lg font-medium leading-5 text-gray-500"
      >
        <div class="flex items-baseline justify-between">
          <img
            alt="deploy image"
            src="/images/deploy.svg"
            class="mr-3 h-6 w-6 hover:brightness-150"
          />
          <span><%= @server.deploy_count %> deploys</span>
        </div>
        <span><%= @server.size %> MB</span>
        <span><%= @server.framework %></span>
      </section>

      <%!-- Git repo --%>
      <section id="git_repo">
        <h3 class="mt-8 mb-2 text-lg font-medium leading-5 text-gray-500">
          Git Repo
        </h3>
        <p class="text-sm leading-5 text-gray-900">
          <%= @server.git_repo %>
        </p>
      </section>

      <%!-- Last commit ID --%>
      <section id="last-commit-id">
        <h3 class="mt-5 mb-2 text-lg font-medium leading-5 text-gray-500">
          Last Commit
        </h3>
        <p class="text-sm leading-5 text-gray-900">
          <%= @server.last_commit_id %>
        </p>
      </section>

      <%!-- Last commit message --%>
      <section id="last-commit-message">
        <blockquote class="mt-5 border-l-4 border-gray-300 p-2 text-base leading-5 text-gray-700">
          <%= @server.last_commit_message %>
        </blockquote>
      </section>
    </div>
    """
  end

  attr :for, Phoenix.HTML.Form, required: true
  attr :id, :string, required: true
  attr :submit, :string, required: true
  attr :change, :string, required: true
  attr :target, Phoenix.LiveComponent.CID, required: true
  attr :class, :string, default: nil
  slot :inner_block, required: true

  def server_form(assigns) do
    ~H"""
    <.form
      for={@for}
      id={@id}
      phx-submit={@submit}
      phx-change={@change}
      phx-target={@target}
      class={[
        "border-solid border border-cool-gray-400 rounded-md p-8 mb-8 shadow-lg relative",
        "#{@class}"
      ]}
    >
      <%= render_slot(@inner_block) %>
    </.form>
    """
  end

  attr :form, Phoenix.HTML.Form, required: true

  def name(assigns) do
    ~H"""
    <.input
      field={@form[:name]}
      label="Name"
      placeholder="Name"
      autocomplete="off"
      phx-debounce="750"
      phx-mounted={JS.focus()}
      wrapper_class="mb-2"
      class={field_class()}
      error_class={error_class()}
      label_class={label_class()}
    />
    """
  end

  attr :form, Phoenix.HTML.Form, required: true

  def framework(assigns) do
    ~H"""
    <.input
      field={@form[:framework]}
      label="Framework"
      placeholder="Framework"
      autocomplete="off"
      phx-debounce="750"
      wrapper_class="mb-2"
      class={field_class()}
      error_class={error_class()}
      label_class={label_class()}
    />
    """
  end

  attr :form, Phoenix.HTML.Form, required: true

  def size(assigns) do
    ~H"""
    <.input
      field={@form[:size]}
      type="number"
      label="Size"
      placeholder="Size (MB)"
      autocomplete="off"
      phx-debounce="750"
      wrapper_class="mb-2"
      class={field_class()}
      error_class={error_class()}
      label_class={label_class()}
    />
    """
  end

  attr :form, Phoenix.HTML.Form, required: true

  def git_repo(assigns) do
    ~H"""
    <.input
      field={@form[:git_repo]}
      label="Git Repo"
      placeholder="Git repo"
      autocomplete="off"
      phx-debounce="750"
      wrapper_class="mb-2"
      class={field_class()}
      error_class={error_class()}
      label_class={label_class()}
    />
    """
  end

  attr :disable_with, :string, required: true

  def save_button(assigns) do
    ~H"""
    <button
      phx-disable-with={@disable_with}
      class="mt-3 w-24 rounded-md border border-transparent bg-indigo-500 px-4 py-2 text-lg font-medium text-white outline-none hover:bg-indigo-700 focus:bg-indigo-700"
    >
      Save
    </button>
    """
  end

  attr :patch, :string, required: true

  def cancel_button(assigns) do
    ~H"""
    <.link
      patch={@patch}
      class="mt-3 ml-2 py-2 px-4 border-2 border-cool-gray-600 font-medium rounded-md text-cool-gray-600 outline-none text-lg hover:bg-cool-gray-600 hover:text-white focus:bg-cool-gray-600 focus:text-white"
    >
      Cancel
    </.link>
    """
  end

  attr :patch, :string, required: true

  def close_icon(assigns) do
    ~H"""
    <.link
      patch={@patch}
      title="Close"
      class="absolute top-6 right-5 -m-3 p-3 opacity-20 hover:opacity-40"
    >
      <.icon name="hero-x-mark-solid" class="h-5 w-5" />
    </.link>
    """
  end

  @spec dom_id(%Server{} | nil) :: String.t()
  def dom_id(nil), do: ""
  def dom_id(server), do: "servers-#{server.id}"

  ## Private functions

  defp field_class do
    # class={[
    #   "w-full appearance-none px-3 py-2 border rounded-md transition
    #       duration-150 ease-in-out text-xl placeholder-slate-400 mt-0",
    #   "phx-no-feedback:border-slate-400 phx-no-feedback:focus:border-teal-300
    #       phx-no-feedback:focus:outline-none phx-no-feedback:focus:ring
    #       phx-no-feedback:focus:ring-teal-300",
    #   "border-slate-400 focus:border-teal-300 focus:outline-none focus:ring
    #       focus:ring-teal-300"
    # ]}
    [
      "w-full appearance-none px-3 py-2 border rounded-md transition duration-150 ease-in-out text-xl placeholder-slate-400 mt-0",
      "phx-no-feedback:border-slate-400 phx-no-feedback:focus:border-teal-300 phx-no-feedback:focus:outline-none phx-no-feedback:focus:ring phx-no-feedback:focus:ring-teal-300",
      "border-slate-400 focus:border-teal-300 focus:outline-none focus:ring focus:ring-teal-300"
    ]
  end

  defp error_class do
    # class="!mt-0.5 !text-rose-700"
    "!mt-0.5 !text-rose-700"
  end

  defp label_class do
    # class="ml-1 mt-3"
    "ml-1 mt-3"
  end
end
