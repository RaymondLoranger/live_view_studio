defmodule LiveView.StudioWeb.Router do
  use LiveView.StudioWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {LiveView.StudioWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LiveView.StudioWeb do
    pipe_through :browser

    get "/", PageController, :home

    live "/light", LightLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", LiveView.StudioWeb do
  #   pipe_through :api
  # end
end
