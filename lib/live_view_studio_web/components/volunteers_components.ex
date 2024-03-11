defmodule LiveView.StudioWeb.VolunteersComponents do
  use LiveView.StudioWeb, [:html, :aliases]

  @field_class [
    "w-full appearance-none px-3 py-2 border rounded-md transition duration-150 ease-in-out text-xl placeholder-slate-400 mt-0",
    "phx-no-feedback:border-slate-400 phx-no-feedback:focus:border-teal-300 phx-no-feedback:focus:outline-none phx-no-feedback:focus:ring phx-no-feedback:focus:ring-teal-300",
    "border-slate-400 focus:border-teal-300 focus:outline-none focus:ring focus:ring-teal-300"
  ]

  @error_class "!mt-0.5 !text-rose-800"

  attr :header, :string, required: true
  attr :id, :string, required: true
  slot :inner_block, required: true

  @spec volunteers(Socket.assigns()) :: Rendered.t()
  def volunteers(assigns) do
    ~H"""
    <.header inner_class="text-center text-cool-gray-900 font-bold text-4xl mb-8">
      <%= @header %>
    </.header>

    <div id={@id} class="mx-auto mb-6 max-w-3xl">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  attr :id, :string, required: true
  attr :update, :string, required: true
  slot :inner_block, required: true

  def volunteer_items(assigns) do
    ~H"""
    <div id={@id} phx-update={@update}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  attr :msg, :any, required: true

  def unexpected_msg(assigns) do
    ~H"""
    <div class="animate-pulse">Unexpected msg:</div>
    <div class="font-semibold"><%= inspect(@msg) %></div>
    """
  end

  attr :count, :integer, required: true

  def prompt(assigns) do
    ~H"""
    <div class="py-2 text-lg font-bold text-sky-500">
      Go for it! You'll be volunteer #<%= @count %>.
    </div>
    """
  end

  attr :id, :string, required: true
  attr :for, Phoenix.HTML.Form, required: true
  attr :target, Phoenix.LiveComponent.CID, required: true
  attr :change, :string, required: true
  attr :submit, :string, required: true
  slot :inner_block, required: true

  def volunteer_form(assigns) do
    ~H"""
    <.form
      id={@id}
      for={@for}
      phx-target={@target}
      phx-change={@change}
      phx-submit={@submit}
      class="px-6 py-4 border-dashed border-2 border-slate-400 mb-8 flex items-baseline justify-around"
    >
      <%= render_slot(@inner_block) %>
    </.form>
    """
  end

  attr :form, Phoenix.HTML.Form, required: true
  attr :field_class, :list, default: @field_class
  attr :error_class, :string, default: @error_class

  def name(assigns) do
    ~H"""
    <.input
      field={@form[:name]}
      placeholder="Name"
      autocomplete="off"
      phx-debounce="2000"
      wrapper_class="flex-1 mr-4"
      class={@field_class}
      error_class={@error_class}
    />
    """
  end

  attr :volunteer, Volunteer, required: true

  def item_name(assigns) do
    ~H"""
    <div class="justify-self-start overflow-auto font-bold text-teal-600">
      <%= @volunteer.name %>
    </div>
    """
  end

  attr :form, Phoenix.HTML.Form, required: true
  attr :field_class, :list, default: @field_class
  attr :error_class, :string, default: @error_class

  def phone(assigns) do
    ~H"""
    <.input
      field={@form[:phone]}
      type="tel"
      placeholder="Phone"
      autocomplete="off"
      phx-debounce="blur"
      phx-hook="PhoneNumber"
      wrapper_class="flex-1 mr-4"
      class={@field_class}
      error_class={@error_class}
    />
    """
  end

  attr :volunteer, Volunteer, required: true

  def item_phone(assigns) do
    ~H"""
    <div class="flex items-center justify-self-start whitespace-nowrap font-medium text-slate-500">
      <img class="mt-0.5 mr-2 h-5 w-5" src="/images/phone.svg" />
      <%= @volunteer.phone %>
    </div>
    """
  end

  attr :disable_with, :string, required: true

  def check_in_button(assigns) do
    ~H"""
    <.button
      phx-disable-with={@disable_with}
      class={[
        "py-2 px-4 border border-transparent rounded-md bg-amber-400 transition duration-150 ease-in-out outline-none flex-initial w-28 hover:bg-yellow-500 focus:outline-none focus:border-yellow-700 focus:ring focus:ring-yellow-300",
        "font-medium text-white text-lg"
      ]}
    >
      Check In
    </.button>
    """
  end

  attr :id, :string, required: true
  attr :volunteer, Volunteer, required: true
  slot :inner_block, required: true

  def volunteer_item(assigns) do
    ~H"""
    <div
      id={@id}
      out={@volunteer.checked_out}
      class={[
        "group relative mt-2 grid h-20 w-full grid-cols-3 items-center rounded border border-slate-300 bg-white px-6 py-4 text-lg",
        "out:bg-slate-300"
      ]}
    >
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  attr :volunteer, Volunteer, required: true
  attr :click, :string, required: true
  attr :id, :string, required: true
  attr :target, Phoenix.LiveComponent.CID, required: true
  attr :disable_with, :string, required: true

  def check_in_out_button(assigns) do
    ~H"""
    <div class="flex items-center justify-self-end text-center text-base font-bold text-teal-600">
      <button
        out={@volunteer.checked_out}
        class={[
          "w-28 rounded px-4 py-2 font-medium text-white outline-none",
          "bg-teal-500 hover:bg-teal-700",
          "out:bg-slate-400 hover:out:bg-slate-600"
        ]}
        phx-click={@click}
        phx-value-id={@id}
        phx-target={@target}
        phx-disable-with={@disable_with}
      >
        <%= text(@volunteer) %>
      </button>
    </div>
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

  ## Private functions

  @spec text(%Volunteer{}) :: String.t()
  defp text(%Volunteer{checked_out: true}), do: "Check In"
  defp text(%Volunteer{checked_out: false}), do: "Check Out"
end
