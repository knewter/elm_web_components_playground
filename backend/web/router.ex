defmodule Backend.Router do
  use Backend.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api_protected do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.EnsureAuthenticated, handler: Backend.AuthErrorHandler
    plug Guardian.Plug.LoadResource
    plug Guardian.Plug.EnsureResource
  end

  pipeline :api_public do
    plug :accepts, ["json"]
  end

  scope "/", Backend do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", Backend do
    pipe_through :api_protected

    resources "/subscriptions", SubscriptionsController, only: [:create]
  end

  scope "/api", Backend do
    pipe_through :api_public

    resources "/users", UserController, except: [:new, :edit]
    post "/authenticate", AuthenticationController, :create
  end
end
