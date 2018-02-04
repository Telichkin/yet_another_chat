defmodule YetAnotherChatWeb.UsersController do
  use YetAnotherChatWeb, :controller

  def create(conn, _params) do
    conn
    |> redirect(to: page_path(YetAnotherChatWeb.Endpoint, :index))
  end

  def show(conn, %{"name" => name}) do
    conn
    |> render(:show, [name: name])
  end
end
