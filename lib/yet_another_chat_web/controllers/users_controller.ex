defmodule YetAnotherChatWeb.UsersController do
  use YetAnotherChatWeb, :controller

  def create(conn, %{"name" => _, "email" => _, "password" => _}) do
    conn
    |> redirect(to: page_path(YetAnotherChatWeb.Endpoint, :index))
  end
  def create(conn, %{}) do
    conn
    |> put_flash(:error, "Name can't be blank \nEmail can't be blank \nPassword can't be blank")
    |> render(:create)
  end

  def show(conn, %{"name" => name}) do
    conn
    |> render(:show, [name: name])
  end
end
