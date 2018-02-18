defmodule YetAnotherChat.AuthController do
  use YetAnotherChat, :controller
  alias YetAnotherChat.User
  import Plug.Conn.Query, only: [decode: 1]

  def register(%{method: "GET"} = conn, _), do: render(conn, :register, %{errors: []})
  def register(%{method: "POST"} = conn, %{} = user_data) do
    case User.create(user_data) do
      {:ok, user} -> 
        conn 
        |> put_session(:current_user, user.name)
        |> redirect(to: chat_path(YetAnotherChat.Endpoint, :index))
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
      nil -> chat_path(YetAnotherChat.Endpoint, :index)
      uri -> uri
    end 
    redirect(conn, to: page)
  end

  def logout(conn, _) do
    conn 
    |> clear_session() 
    |> redirect(to: chat_path(YetAnotherChat.Endpoint, :index))
  end
end
