defmodule YetAnotherChat.ChatController do
  use YetAnotherChat, :controller

  def index(conn, _params) do
    redirect(conn, to: chat_path(conn, :show, "lobby"))
  end

  def show(conn, %{"name" => _name}) do
    render(conn, :chat)
  end
end
