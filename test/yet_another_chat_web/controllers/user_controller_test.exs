defmodule YetAnotherChatWeb.UserControllerTest do
  use YetAnotherChatWeb.ConnCase

  test "create a user with name, email and password", %{conn: conn} do
    conn = post(conn, "/users", %{"name" => "Roman", "email" => "some@mail.com", "password" => "StrongPWD!"})
    assert redirected_to(conn) =~ "/"
    assert get_session(conn, :current_user)

    conn = get(conn, "/users/Roman")
    assert html_response(conn, 200) =~ "Hello, Roman"
  end

  test "can't create a user without email or name or password", %{conn: conn} do
    conn = post(conn, "/users", %{"name" => "Roman"})
    refute html_response(conn, 200) =~ "Name can&#39;t be blank"
    assert html_response(conn, 200) =~ "Email can&#39;t be blank"
    assert html_response(conn, 200) =~ "Password can&#39;t be blank"

    conn = post(conn, "/users", %{"name" => "", "email" => "", "password" => ""})
    assert html_response(conn, 200) =~ "Name can&#39;t be blank"
    assert html_response(conn, 200) =~ "Email can&#39;t be blank"
    assert html_response(conn, 200) =~ "Password can&#39;t be blank"

    refute get_session(conn, :current_user)    
  end

  test "can't create a user when name already exists", %{conn: conn} do
    conn = post(conn, "/users", %{"name" => "Roman", "email" => "some@mail.com", "password" => "StrongPWD!"})
    
    conn = post(conn, "/users", %{"name" => "Roman", "email" => "other@mail.com", "password" => "weakPWD!"})
    assert html_response(conn, 200) =~ "Name has already been taken"
  end

  test "can't create a user when email already taken", %{conn: conn} do
    conn = post(conn, "/users", %{"name" => "Roman", "email" => "some@mail.com", "password" => "StrongPWD!"})
    
    conn = post(conn, "/users", %{"name" => "Drum", "email" => "some@mail.com", "password" => "weakPWD!"})
    assert html_response(conn, 200) =~ "Email has already been taken"
  end
end
