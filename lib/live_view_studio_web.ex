defmodule LiveView.StudioWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, components, channels, and so on.

  This can be used in your application as:

      use LiveView.StudioWeb, :controller
      use LiveView.StudioWeb, :html

  The definitions below will be executed for every controller,
  component, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define additional modules and import
  those modules here.
  """

  #                                                                   ↓ ↓ ↓ ↓
  def static_paths, do: ~w(assets fonts images favicon.ico robots.txt uploads)

  def router do
    quote do
      use Phoenix.Router, helpers: false

      # Import common connection and controller functions to use in pipelines
      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
    end
  end

  def controller do
    quote do
      use Phoenix.Controller,
        formats: [:html, :json],
        layouts: [html: LiveView.StudioWeb.Layouts]

      import Plug.Conn
      import LiveView.StudioWeb.Gettext

      unquote(verified_routes())
    end
  end

  def live_view do
    quote do
      use Phoenix.LiveView, layout: {LiveView.StudioWeb.Layouts, :app}

      unquote(html_helpers())
    end
  end

  def live_component do
    quote do
      use Phoenix.LiveComponent

      unquote(html_helpers())
    end
  end

  def html do
    quote do
      use Phoenix.Component

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_csrf_token: 0, view_module: 1, view_template: 1]

      # Include general helpers for rendering HTML
      unquote(html_helpers())
    end
  end

  defp html_helpers do
    quote do
      # HTML escaping functionality
      import Phoenix.HTML
      # Core UI components and translation
      import LiveView.StudioWeb.CoreComponents
      import LiveView.StudioWeb.CommonComponents
      import LiveView.StudioWeb.Gettext

      # Shortcut for generating JS commands
      alias Phoenix.LiveView.JS

      # Routes generation with the ~p sigil
      unquote(verified_routes())
    end
  end

  def verified_routes do
    quote do
      use Phoenix.VerifiedRoutes,
        endpoint: LiveView.StudioWeb.Endpoint,
        router: LiveView.StudioWeb.Router,
        statics: LiveView.StudioWeb.static_paths()
    end
  end

  def imports do
    quote do
      import Enum, only: [with_index: 1]

      import LiveView.Studio.Donations,
        only: [almost_expired?: 1, list_donations: 1, donations_count: 0]

      import LiveView.Studio.Vehicles,
        only: [list_vehicles: 1, vehicles_count: 0]

      import Number.Currency
      import Phoenix.HTML.Form, only: [options_for_select: 2]
      import Phoenix.Naming, only: [humanize: 1]
    end
  end

  def aliases do
    quote do
      alias LiveView.StudioWeb.{
        BoatsComponents,
        DeskForm,
        DesksComponents,
        DonationsComponents,
        Endpoint,
        FlightsComponents,
        Geo,
        GitReposComponents,
        IncidentsComponents,
        JugglingComponents,
        LicenseComponents,
        LightComponents,
        PerPageForm,
        PizzasComponents,
        Router,
        SalesComponents,
        SalesLive,
        SandboxComponents,
        SandboxForm,
        SandboxZipForm,
        ServerForm,
        ServerLayout,
        ServersComponents,
        StoresComponents,
        TOCComponents,
        UnderwaterComponents,
        VehiclesComponents,
        VolunteerForm,
        VolunteerItem,
        VolunteersComponents
      }

      alias LiveView.Studio.{
        Airports,
        Boats,
        Cities,
        Desks,
        Donations,
        Flights,
        GitRepos,
        Incidents,
        Licenses,
        PizzaOrders,
        Sales,
        Sandbox,
        Servers,
        Stores,
        Volunteers
      }

      alias LiveView.Studio.Boats.Boat
      alias LiveView.Studio.Desks.Desk
      alias LiveView.Studio.Donations.Donation
      alias LiveView.Studio.Flights.Flight
      alias LiveView.Studio.GitRepos.GitRepo
      alias LiveView.Studio.Incidents.Incident
      alias LiveView.Studio.PizzaOrders.PizzaOrder
      alias LiveView.Studio.Servers.Server
      alias LiveView.Studio.Stores.Store
      alias LiveView.Studio.Vehicles.Vehicle
      alias LiveView.Studio.Volunteers.Volunteer

      alias Phoenix.LiveView, as: LV
      alias Phoenix.LiveView.{JS, Rendered, Socket, UploadEntry}
      alias Phoenix.Socket.Broadcast
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(whiches) when is_list(whiches) do
    for which <- whiches do
      quote do
        unquote(apply(__MODULE__, which, []))
      end
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
