defmodule LiveView.StudioWeb.GitReposLive do
  use LiveView.StudioWeb, [:live_view, :aliases]

  import GitReposComponents

  @spec mount(LV.unsigned_params(), map, Socket.t()) ::
          {:ok, Socket.t(), keyword}
  def mount(_params, _session, socket) do
    socket = assign(socket, :page_title, "Git Repos")
    # Contrarily to [], nil allows to properly handle events returning []...
    {:ok, assign_defaults(socket), temporary_assigns: [repos: nil]}
  end

  @spec render(Socket.assigns()) :: Rendered.t()
  def render(assigns) do
    ~H"""
    <.repos id="git-repos" header="Trending Git Repos 👨‍💻">
      <.focus_wrap id="filter-form-focus-wrap">
        <.filter_form id="filter-form" change="filter">
          <.select_language language={@language} />
          <.select_license license={@license} />
          <.clear_button click="clear" />
        </.filter_form>
      </.focus_wrap>

      <.repos_found id="repos-found" update="replace">
        <.repo_found :for={repo <- @repos} id={"repo-#{repo.id}"}>
          <.repo_first_line repo={repo} />
          <.repo_second_line repo={repo} />
        </.repo_found>
      </.repos_found>
    </.repos>
    """
  end

  @spec handle_event(event :: binary, LV.unsigned_params(), Socket.t()) ::
          {:noreply, Socket.t()}
  def handle_event("filter", params, socket) do
    criteria = [language: params["language"], license: params["license"]]
    repos = GitRepos.list_git_repos(criteria)
    {:noreply, assign_repos(socket, repos) |> assign(criteria)}
  end

  def handle_event("clear", _payload, socket) do
    {:noreply, assign_defaults(socket)}
  end

  ## Private functions

  defp assign_defaults(socket) do
    assign(socket, repos: GitRepos.list_git_repos(), language: "", license: "")
  end

  @spec assign_repos(Socket.t(), [%GitRepo{}]) :: Socket.t()
  defp assign_repos(socket, _repos = []) do
    socket |> put_flash(:error, "No matching repos...") |> assign(repos: [])
  end

  defp assign_repos(socket, repos) do
    socket |> clear_flash() |> assign(repos: repos)
  end
end
