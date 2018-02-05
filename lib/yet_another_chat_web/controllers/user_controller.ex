defmodule YetAnotherChatWeb.UserController do
  use YetAnotherChatWeb, :controller
  
  def show(conn, %{"name" => name}) do
    conn
    |> render(:show, [name: name])
  end
end
