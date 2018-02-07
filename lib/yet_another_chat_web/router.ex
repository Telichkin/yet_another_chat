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
    
    get "/register", AuthController, :show_register    
    post "/register", AuthController, :register
    
    get "/login", AuthController, :show_login
    post "/login", AuthController, :login    
    
    post "/logout", AuthController, :logout

    get "/users/:name", UserController, :show
  end
end
