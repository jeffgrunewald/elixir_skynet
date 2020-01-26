defmodule SkynetWeb.Router do
  use SkynetWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", SkynetWeb do
    pipe_through :api

    resources "/terminators", TerminatorController, only: [:index, :create, :delete]
  end

  scope "/", SkynetWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", SkynetWeb do
  #   pipe_through :api
  # end
end
