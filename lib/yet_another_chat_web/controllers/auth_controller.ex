defmodule YetAnotherChatWeb.AuthController do
  use YetAnotherChatWeb, :controller
  alias YetAnotherChat.User
  import Plug.Conn.Query, only: [decode: 1]

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

  def show_register(conn, _), do: render(conn, :register, %{errors: []})

  def login(conn, %{"login" => login, "password" => password}) do
    case User.find_name_by_login_and_password(login, password) do
      nil ->
        conn
        |> put_flash(:error, "Invalid login or password")
        |> render(:login)
      name ->         
        conn
        |> put_session(:current_user, name)
        |> redirect_to_previous_page()
    end
  end

  defp redirect_to_previous_page(conn) do
    page = case decode(conn.query_string)["previous-page"] do
      nil -> page_path(YetAnotherChatWeb.Endpoint, :index)
      uri -> uri
    end 
    redirect(conn, to: page)
  end

  def show_login(conn, _), do: render(conn, :login)

  def logout(conn, _), do: clear_session(conn)
end
