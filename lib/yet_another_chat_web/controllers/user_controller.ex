defmodule YetAnotherChatWeb.UserController do
  use YetAnotherChatWeb, :controller

  def show(%{assigns: %{user: :anon}} = conn, _) do
    conn 
    |> forbidden("Oops... You should be logged in")
  end

  def show(%{assigns: %{user: name}} = conn, %{"name" => name}) do
    conn
    |> render(:show, [name: name])
  end

  def show(%{assigns: %{user: _name}} = conn, _) do
    conn 
    |> forbidden("Oops... Looks like it's not your page")
  end

  defp forbidden(conn, message) do
    conn
    |> put_view(YetAnotherChatWeb.ErrorView)
    |> put_status(403)
    |> render(:"403", %{error: message})
    |> halt()
  end
end
