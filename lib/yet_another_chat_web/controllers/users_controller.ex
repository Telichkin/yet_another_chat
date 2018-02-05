defmodule YetAnotherChatWeb.UsersController do
  use YetAnotherChatWeb, :controller
  alias YetAnotherChat.User
  require Logger

  def create(conn, %{} = user) do
    case User.create(user) do
      {:ok, _} -> redirect(conn, to: page_path(YetAnotherChatWeb.Endpoint, :index))
      {:error, changeset} -> render(conn, :create, %{errors: changeset.errors})
    end
  end

  def show(conn, %{"name" => name}) do
    conn
    |> render(:show, [name: name])
  end
end
