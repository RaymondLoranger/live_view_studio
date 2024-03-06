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

    live "/boats", BoatsLive
    live "/donations", DonationsLive, :paginate
    live "/donations/paginate", DonationsLive, :paginate
    live "/donations/sort", DonationsLive, :sort
    live "/flights", FlightsLive
    live "/light", LightLive
    live "/pizzas", PizzasLive
    live "/sales", SalesLive
    live "/sandbox", SandboxLive
    live "/servers", ServersLive
    live "/servers/:id", ServersLive
    live "/servers/new/form", ServersLive, :form_new
    live "/servers/new/modal", ServersLive, :modal_new
    live "/server-names", ServerNamesLive
    live "/server-names/:name", ServerNamesLive
    live "/vehicles", VehiclesLive
    live "/volunteers", VolunteersLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", LiveView.StudioWeb do
  #   pipe_through :api
  # end
end
