defmodule LiveView.StudioWeb.DeskForm do
  use LiveView.StudioWeb, [:live_component, :aliases]

  import DesksComponents

  @empty_form Desks.change_desk(%Desk{}) |> to_form()
  @empty_payload %{"desk" => %{"name" => "", "photo_locations" => []}}

  @spec mount(Socket.t()) :: {:ok, Socket.t()}
  def mount(socket) do
    {:ok,
     socket
     |> assign(:form, @empty_form)
     |> allow_upload(:photo,
       accept: ~w(.png .jpeg .jpg),
       max_entries: 6,
       # 91_540_684.8 => 91_540_685
       max_file_size: round(87.3 * 1024 * 1024)
     )}
  end

  @spec render(Socket.assigns()) :: Rendered.t()
  def render(assigns) do
    ~H"""
    <article>
      <.desk_form
        id="desk-form"
        for={@form}
        target={@myself}
        submit="save"
        change="validate"
      >
        <.desk_name form={@form} placeholder="Name" autofocus="true" />
        <.drag_and_drop_area uploads={@uploads} />
        <.entries_error uploads={@uploads} />

        <.entry_preview :for={entry <- @uploads.photo.entries}>
          <.live_img_preview entry={entry} class="w-32" />
          <.entry_progress entry={entry} />
          <.cancel_icon target={@myself} click="cancel" ref={entry.ref} />
          <.entry_error uploads={@uploads} entry={entry} />
        </.entry_preview>

        <.upload_button disable_with="Uploading..." text="Upload" />
      </.desk_form>
    </article>
    """
  end

  @spec handle_event(event :: binary, LV.unsigned_params(), Socket.t()) ::
          {:noreply, Socket.t()}
  def handle_event("save", %{"desk" => params}, socket) do
    # The "save" event is sent once the photos have been uploaded to
    # a temporary directory waiting to be "consumed" and then served.
    photo_locations = photo_locations(socket)
    params = Map.put(params, "photo_locations", photo_locations)

    case Desks.create_desk(params, &consume_photos(socket, &1)) do
      {:ok, _desk} ->
        {:noreply, assign(socket, form: @empty_form)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  def handle_event("validate", @empty_payload, socket) do
    {:noreply, assign(socket, form: @empty_form)}
  end

  def handle_event("validate", %{"desk" => params}, socket) do
    changeset = Desks.validate(%Desk{}, params)
    {:noreply, assign(socket, :form, to_form(changeset))}
  end

  def handle_event("cancel", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :photo, ref)}
  end

  # Private functions

  @spec consume_photos(Socket.t(), %Desk{}) :: {:ok, %Desk{}}
  defp consume_photos(socket, desk) do
    consume_photos(socket)
    {:ok, desk}
  end

  # Directory `static/uploads` must exist for `File.cp!/2` to work
  # and `LiveView.StudioWeb.static_paths/0` must contain `uploads`.
  @spec consume_photos(Socket.t()) :: [:ok]
  defp consume_photos(socket) do
    consume_uploaded_entries(socket, :photo, fn %{path: path} = _meta, entry ->
      dest = Path.join("priv/static/uploads", basename(entry))
      {:ok, :ok = File.cp!(path, dest)}
    end)
  end

  @spec photo_locations(Socket.t()) :: [Path.t()]
  defp photo_locations(socket) do
    {completed_entries, []} = uploaded_entries(socket, :photo)
    for entry <- completed_entries, do: ~p"/uploads/#{basename(entry)}"
  end

  @spec basename(%UploadEntry{}) :: Path.t()
  defp basename(entry) do
    "#{entry.uuid}-#{entry.client_name}"
  end
end
