defmodule LiveView.StudioWeb.LightComponents do
  use LiveView.StudioWeb, [:html, :aliases]

  attr :header, :string, required: true
  attr :subtitle, :string, required: true
  attr :id, :string, required: true
  attr :keyup, :string, required: true
  slot :inner_block, required: true

  @spec light(Socket.assigns()) :: Rendered.t()
  def light(assigns) do
    ~H"""
    <.header
      inner_class="text-cool-gray-900 mb-6 text-center text-4xl font-extrabold"
      subtitle_class="text-cool-gray-700 mb-4 text-center text-lg font-medium"
    >
      <%= @header %>
      <:subtitle>
        <%= @subtitle %>
      </:subtitle>
    </.header>

    <section
      id={@id}
      phx-window-keyup={@keyup}
      class="mx-auto mb-10 max-w-xl rounded-xl border-2 border-double border-slate-400 bg-slate-100 p-10 text-center"
    >
      <%= render_slot(@inner_block) %>
    </section>
    """
  end

  attr :temp, :integer, required: true
  attr :brightness, :integer, required: true

  def meter(assigns) do
    ~H"""
    <div
      id="meter"
      class="bg-cool-gray-300 mb-8 flex h-12 overflow-hidden rounded-lg text-base hover:bg-cool-gray-200"
    >
      <span
        c3={@temp == 3000}
        c4={@temp == 4000}
        c5={@temp == 5000}
        c6={@temp == 6000}
        class={[
          "text-cool-gray-900 transition-width flex flex-col justify-center whitespace-nowrap font-bold duration-1000 ease-in-out",
          "c3:bg-[#F1C40D] hover:c3:bg-[#f7dc6e]",
          "c4:bg-[#00ff99] hover:c4:bg-[#80ffcc]",
          "c5:bg-[#99CCFF] hover:c5:bg-[#cce6ff]",
          "c6:bg-[#FF4D4D] hover:c6:bg-[#ff9999]"
        ]}
        style={"width: #{@brightness}%;"}
      >
        <%= @brightness %>%
      </span>
    </div>
    """
  end

  attr :click, :string, required: true
  attr :disabled, :boolean, default: false
  attr :svg, :string, required: true

  def btn(assigns) do
    ~H"""
    <button
      id={@click}
      title={@click}
      phx-click={@click}
      disabled={@disabled}
      class="border-cool-gray-400 m-1 rounded-lg border-2 bg-transparent px-4 py-2 shadow-lg outline-none transition duration-700 ease-in-out hover:bg-cool-gray-300 focus:border-indigo-600 disabled:cursor-not-allowed disabled:opacity-50"
    >
      <img class="w-10" src={"/images/#{@svg}.svg"} />
    </button>
    """
  end

  attr :change, :string, required: true
  attr :brightness, :integer, required: true
  attr :focus, :string, required: true
  attr :blur, :string, required: true

  # Any arrow key will change the slider value by ±1 when it has focus.
  def slider(assigns) do
    ~H"""
    <form phx-change={@change} class="mx-auto mt-11 w-full">
      <input
        id="slider"
        type="range"
        value={@brightness}
        min="0"
        max="100"
        name="brightness"
        phx-focus={@focus}
        phx-blur={@blur}
        phx-debounce="250"
      />
    </form>
    """
  end

  attr :change, :string, required: true
  attr :temp, :integer, required: true
  attr :temps, :list, required: true

  # ArrowLeft/ArrowRight will switch radio button when one has focus.
  # ArrowUp/ArrowDown are prevented to do so by the 'onkeydown' code.
  def selector(assigns) do
    ~H"""
    <form
      id="temp"
      phx-change={@change}
      class="mx-auto mt-11 flex flex-col items-center justify-evenly gap-2 md:flex-row"
    >
      <fieldset
        :for={temp <- @temps}
        class="flex items-center justify-center gap-2"
      >
        <%!-- 'checked' removed when @checked is false --%>
        <%!-- Prevent ArrowUp/ArrowDown keys from switching radio button --%>
        <input
          class="w-4"
          type="radio"
          id={"temp-#{temp}"}
          name="temp"
          value={temp}
          checked={temp == @temp}
          onkeydown="return !['ArrowUp', 'ArrowDown'].includes(event.key);"
        />
        <label
          for={"temp-#{temp}"}
          c3={temp == 3000}
          c4={temp == 4000}
          c5={temp == 5000}
          c6={temp == 6000}
          class={[
            "rounded-lg border-2 px-1 font-medium",
            "c3:bg-[#F1C40D] c3:border-[#917608] hover:c3:bg-[#f7dc6e]",
            "c4:bg-[#00ff99] c4:border-[#00b36b] hover:c4:bg-[#80ffcc]",
            "c5:bg-[#99CCFF] c5:border-[#4da6ff] hover:c5:bg-[#cce6ff]",
            "c6:bg-[#FF4D4D] c6:border-[#e60000] hover:c6:bg-[#ff9999]"
          ]}
        >
          <%= temp %>℃
        </label>
      </fieldset>
    </form>
    """
  end
end
