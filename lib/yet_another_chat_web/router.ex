defmodule YetAnotherChatWeb.Router do
  use YetAnotherChatWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :fetch_user
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", YetAnotherChatWeb do
    pipe_through :browser

    get "/", PageController, :index
    
    get "/register", AuthController, :register    
    post "/register", AuthController, :register
    
    get "/login", AuthController, :login
    post "/login", AuthController, :login    
    
    post "/logout", AuthController, :logout

    get "/users/:name", UserController, :show
  end

  defp fetch_user(conn, _) do
    case get_session(conn, :current_user) do
      nil -> assign(conn, :user, :anon)
      name -> assign(conn, :user, name)
    end
  end
end