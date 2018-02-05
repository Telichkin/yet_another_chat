defmodule YetAnotherChatWeb.SessionController do
  use YetAnotherChatWeb, :controller
  alias YetAnotherChat.User

  def register(conn, %{} = user_data) do
    case User.create(user_data) do
      {:ok, user} -> 
        conn 
        |> put_session(:current_user, user.name)
        |> redirect(to: page_path(YetAnotherChatWeb.Endpoint, :index))
      {:error, changeset} -> 
        conn
        |> render(:register, %{errors: changeset.errors})
    end
  end
end
