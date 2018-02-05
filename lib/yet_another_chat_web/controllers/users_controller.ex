defmodule YetAnotherChatWeb.UsersController do
  use YetAnotherChatWeb, :controller
  alias YetAnotherChat.User
  require Logger

  def create(conn, %{} = user_data) do
    case User.create(user_data) do
      {:ok, user} -> 
        conn 
        |> put_session(:current_user, user.name)
        |> redirect(to: page_path(YetAnotherChatWeb.Endpoint, :index))
      {:error, changeset} -> 
        conn
        |> render(:create, %{errors: changeset.errors})
    end
  end

  def show(conn, %{"name" => name}) do
    conn
    |> render(:show, [name: name])
  end
end
