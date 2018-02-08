defmodule YetAnotherChatWeb.UserController do
  use YetAnotherChatWeb, :controller
  plug :user_should_be_logged_in

  defp user_should_be_logged_in(conn, _) do
    case get_session(conn, :current_user) do
      nil -> 
        conn 
        |> put_view(YetAnotherChatWeb.ErrorView)
        |> put_status(403)
        |> render(:"403", %{error: "Oops... You should be logged in"})
        |> halt()
      _ ->
        conn
    end
  end

  def show(conn, %{"name" => name}) do
    case get_session(conn, :current_user) do
      ^name ->
        conn
        |> render(:show, [name: name])
      _ ->
        conn 
        |> put_view(YetAnotherChatWeb.ErrorView)
        |> put_status(403)
        |> render(:"403", %{error: "Oops... Looks like it's not your page"})
        |> halt()
    end
  end
end
