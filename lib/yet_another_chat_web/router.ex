defmodule YetAnotherChatWeb.Router do
  use YetAnotherChatWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", YetAnotherChatWeb do
    pipe_through :browser

    get "/", PageController, :index
    
    post "/register", SessionController, :register
    
    get "/users/:name", UserController, :show
  end
end
