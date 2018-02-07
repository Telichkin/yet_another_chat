defmodule YetAnotherChatWeb.AuthController do
  use YetAnotherChatWeb, :controller
  alias YetAnotherChat.User

  def register(conn, %{} = user_data) do
    case User.create(user_data) do
      {:ok, user} -> 
        conn 
        |> put_session(:current_user, user.name)
        |> redirect(to: page_path(YetAnotherChatWeb.Endpoint, :index))
      {:error, changeset} -> 
        conn
        |> render(:register, %{errors: changeset.errors})
    end
  end

  def register_page(conn, _), do: render(conn, :register, %{errors: []})

  def login(conn, %{"login" => login, "password" => password}) do
    case User.find_name_by_login_and_password(login, password) do
      nil ->
        conn
      name ->    
        conn
        |> put_session(:current_user, name)
    end
  end

  def logout(conn, _), do: clear_session(conn)
end
