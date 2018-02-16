defmodule Web.ChatController do
  use Web, :controller

  def index(conn, _params) do
    redirect(conn, to: chat_path(conn, :show, "lobby"))
  end

  def show(conn, %{"name" => _name}) do
    render(conn, :index)
  end
end
