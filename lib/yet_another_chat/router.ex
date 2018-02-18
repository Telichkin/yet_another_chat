defmodule YetAnotherChat.Router do
  use YetAnotherChat, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :fetch_user
    plug :set_user_token
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", YetAnotherChat do
    pipe_through :browser

    get "/", ChatController, :index
    get "/chats/:name", ChatController, :show
    
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

  defp set_user_token(%{assigns: %{user: :anon}} = conn, _), do: conn
  defp set_user_token(%{assigns: %{user: name}} = conn, _) do
    salt = Application.get_env(:yet_another_chat, YetAnotherChat.Endpoint)[:secret_key_base]
    token = Phoenix.Token.sign(conn, salt, name)
    assign(conn, :user_token, token)
  end
end