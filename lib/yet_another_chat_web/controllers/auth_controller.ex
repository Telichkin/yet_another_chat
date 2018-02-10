defmodule YetAnotherChatWeb.AuthController do
  use YetAnotherChatWeb, :controller
  alias YetAnotherChat.User
  import Plug.Conn.Query, only: [decode: 1]

  def register(%{method: "GET"} = conn, _), do: render(conn, :register, %{errors: []})
  def register(%{method: "POST"} = conn, %{} = user_data) do
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

  def login(%{method: "GET"} = conn, _), do: render(conn, :login, %{error: nil}) 
  def login(%{method: "POST"} = conn, %{"login" => login, "password" => password}) do
    case User.find_name_by_login_and_password(login, password) do
      nil ->
        conn
        |> render(:login, %{error: "Invalid login or password"})
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

  def logout(conn, _), do: clear_session(conn)
end
