defmodule LiveView.StudioWeb.DesksComponents do
  use LiveView.StudioWeb, [:html, :imports, :aliases]

  attr :header, :string, required: true
  attr :id, :string, required: true
  slot :inner_block, required: true

  @spec desks(Socket.assigns()) :: Rendered.t()
  def desks(assigns) do
    ~H"""
    <.header inner_class="text-center text-cool-gray-900 font-bold text-4xl mb-8">
      <%= @header %>
    </.header>

    <div id={@id} class="mx-auto mt-8 max-w-5xl">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  attr :id, :string, required: true
  attr :for, Phoenix.HTML.Form, required: true
  attr :target, Phoenix.LiveComponent.CID, required: true
  attr :submit, :string, required: true
  attr :change, :string, required: true
  slot :inner_block, required: true

  def desk_form(assigns) do
    ~H"""
    <.form
      id={@id}
      for={@for}
      phx-target={@target}
      phx-submit={@submit}
      phx-change={@change}
      class="bg-white px-8 py-6 mb-6 shadow rounded-lg mx-auto w-full max-w-xl"
    >
      <%= render_slot(@inner_block) %>
    </.form>
    """
  end

  attr :form, Phoenix.HTML.Form, required: true
  attr :placeholder, :string, required: true
  attr :autofocus, :string, required: true

  def desk_name(assigns) do
    ~H"""
    <.input
      field={@form[:name]}
      placeholder={@placeholder}
      autofocus={@autofocus}
      class={[
        "mb-4 appearance-none block w-full px-3 py-2 border rounded-md placeholder-slate-400 transition duration-150 ease-in-out",
        "phx-no-feedback:border-slate-400 phx-no-feedback:focus:border-indigo-300 phx-no-feedback:focus:outline-none phx-no-feedback:focus:ring phx-no-feedback:focus:ring-indigo-300",
        "border-slate-400 focus:border-indigo-300 focus:outline-none focus:ring focus:ring-indigo-300"
      ]}
      error_class="!-mt-3 !text-rose-800"
    />
    """
  end

  attr :uploads, :map, required: true

  def drag_and_drop_area(assigns) do
    ~H"""
    <div
      phx-drop-target={@uploads.photo.ref}
      class="my-2 flex flex-col space-x-1 rounded-md border-2 border-dashed border-slate-300 p-4 text-center text-slate-600"
    >
      <.drag_and_drop_svg src="/images/upload.svg" />
      <.directive uploads={@uploads} />
      <.hint uploads={@uploads} />
    </div>
    """
  end

  attr :src, :string, required: true

  def drag_and_drop_svg(assigns) do
    ~H"""
    <img src={@src} class="mx-auto h-12 w-12" />
    """
  end

  attr :uploads, :map, required: true

  def directive(assigns) do
    ~H"""
    <div>
      <label
        for={@uploads.photo.ref}
        class="inline-flex cursor-pointer font-medium leading-4 text-indigo-600 focus-within:outline-none focus-within:ring-2 focus-within:ring-indigo-500 focus-within:ring-offset-2 hover:text-indigo-500"
      >
        <span>Upload a file</span>
        <.live_file_input upload={@uploads.photo} class="sr-only" />
      </label>
      <span>or drag and drop here</span>
    </div>
    """
  end

  attr :uploads, :map, required: true

  def hint(assigns) do
    ~H"""
    <p class="text-sm text-slate-500">
      <%= @uploads.photo.max_entries %> photos max,
      up to <%= max_file_size_in_MB(@uploads) %> MB each
    </p>
    """
  end

  attr :uploads, :map, required: true

  def entries_error(assigns) do
    ~H"""
    <.error
      :for={error <- upload_errors(@uploads.photo)}
      error_class=" !text-rose-800 whitespace-nowrap"
    >
      <%= humanize(error) %>
    </.error>
    """
  end

  slot :inner_block, required: true

  def entry_preview(assigns) do
    ~H"""
    <div class="my-6 flex items-center justify-start space-x-6">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  attr :entry, UploadEntry, required: true

  def entry_progress(assigns) do
    ~H"""
    <div class="w-full">
      <.progress_percentage entry={@entry} />
      <.progress_bar entry={@entry} />
    </div>
    """
  end

  attr :entry, UploadEntry, required: true

  def progress_percentage(assigns) do
    ~H"""
    <div class="mb-2 inline-block text-left text-xs font-semibold text-indigo-600">
      <%= @entry.progress %>%
    </div>
    """
  end

  attr :entry, UploadEntry, required: true

  def progress_bar(assigns) do
    ~H"""
    <div class="mb-4 flex h-2 overflow-hidden rounded-lg bg-indigo-200 text-base">
      <span
        style={"width: #{@entry.progress}%;"}
        class="transition-width bg-indigo-500 shadow-md duration-1000 ease-in-out"
      />
    </div>
    """
  end

  attr :target, Phoenix.LiveComponent.CID, required: true
  attr :click, :string, required: true
  attr :ref, :string, required: true
  attr :text, :string, default: "❌"

  def cancel_icon(assigns) do
    ~H"""
    <a
      href="#"
      phx-target={@target}
      phx-click={@click}
      phx-value-ref={@ref}
      class="cursor-pointer text-sm hover:scale-105"
    >
      <%= @text %>
    </a>
    """
  end

  attr :uploads, :map, required: true
  attr :entry, UploadEntry, required: true

  def entry_error(assigns) do
    ~H"""
    <.error
      :for={error <- upload_errors(@uploads.photo, @entry)}
      error_class="!mb-3 !text-rose-800 whitespace-nowrap"
    >
      <%= humanize(error) %>
    </.error>
    """
  end

  attr :disable_with, :string, required: true
  attr :text, :string, required: true

  def upload_button(assigns) do
    ~H"""
    <.button
      phx-disable-with={@disable_with}
      class={[
        "mt-4 w-full py-2 px-4 border border-transparent font-medium rounded-md text-white bg-indigo-600 transition duration-150 ease-in-out",
        "hover:bg-indigo-500 active:bg-indigo-700 focus:outline-none focus:border-indigo-700 focus:ring focus:ring-indigo-300"
      ]}
    >
      <%= @text %>
    </.button>
    """
  end

  attr :id, :string, required: true
  attr :update, :string, required: true
  slot :inner_block, required: true

  def all_photos(assigns) do
    ~H"""
    <div
      id={@id}
      phx-update={@update}
      class="flex flex-wrap place-content-center"
    >
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  attr :id, :string, required: true
  slot :inner_block, required: true

  def desk_photos(assigns) do
    ~H"""
    <div id={@id} class="flex flex-wrap place-content-center">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  attr :id, :string
  attr :desk, Desk, required: true
  attr :index, :integer, required: true
  attr :photo_location, :string, required: true

  def desk_photo(assigns) do
    assigns = assign(assigns, :id, "#{assigns.desk.id}#{assigns.index + 1}")

    ~H"""
    <div
      id={"photo-#{@id}"}
      class="m-4 rounded-xl border-2 border-slate-300 p-4 text-center"
    >
      <figure>
        <img src={@photo_location} class="mx-auto h-64 object-fill sm:h-36" />
        <figcaption class="mt-2 text-base font-medium text-slate-600">
          <%= @desk.name %> (<%= @id %>)
        </figcaption>
      </figure>
    </div>
    """
  end

  # Private functions

  # 87.30000019... => 87.3
  defp max_file_size_in_MB(uploads) do
    Float.round(uploads.photo.max_file_size / (1024 * 1024), 1)
  end
end
