defmodule YetAnotherChatWeb.PageController do
  use YetAnotherChatWeb, :controller

  def index(conn, _params) do
    redirect(conn, to: page_path(conn, :show, "lobby"))
  end

  def show(conn, %{"name" => _name}) do
    render(conn, :index)
  end
end
