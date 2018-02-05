defmodule YetAnotherChatWeb.UsersController do
  use YetAnotherChatWeb, :controller
  require Logger

  @required_fields ["name", "email", "password"]

  def create(conn, %{} = user) do
    case find_empty_fields(user) do
      [] -> redirect(conn, to: page_path(YetAnotherChatWeb.Endpoint, :index))
      empty_fields -> render(conn, :create, %{empty_fields: empty_fields})
    end
  end

  defp find_empty_fields(user) do
    Enum.reduce(@required_fields, [], fn(field, empty_fields) -> 
      field_is_empty = user[field] === "" or user[field] === nil
      case field_is_empty do
        true -> [field | empty_fields]
        false -> empty_fields
      end
    end)
  end

  def show(conn, %{"name" => name}) do
    conn
    |> render(:show, [name: name])
  end
end
