defmodule YetAnotherChatWeb.UserControllerTest do
  use YetAnotherChatWeb.ConnCase

  test "create user with email and password", %{conn: conn} do
    conn = post(conn, "/users", %{"name" => "Roman", "password" => "StrongPWD!"})
    assert redirected_to(conn) =~ "/"

    conn = get(conn, "/users/Roman")
    assert html_response(conn, 200) =~ "Hello, Roman"
  end
end
