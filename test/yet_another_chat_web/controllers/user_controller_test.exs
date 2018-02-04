defmodule YetAnotherChatWeb.UserControllerTest do
  use YetAnotherChatWeb.ConnCase

  test "create a user with name, email and password", %{conn: conn} do
    conn = post(conn, "/users", %{"name" => "Roman", "email" => "some@mail.com", "password" => "StrongPWD!"})
    assert redirected_to(conn) =~ "/"

    conn = get(conn, "/users/Roman")
    assert html_response(conn, 200) =~ "Hello, Roman"
  end

  test "can't create a user without email or name or password", %{conn: conn} do
    conn = post(conn, "/users", %{})
    assert html_response(conn, 200) =~ "Name can&#39;t be blank"
    assert html_response(conn, 200) =~ "Email can&#39;t be blank"
    assert html_response(conn, 200) =~ "Password can&#39;t be blank"    
  end

  test "can't create a user when name already exists"
end