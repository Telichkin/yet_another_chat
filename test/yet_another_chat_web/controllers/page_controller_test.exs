defmodule Web.PageControllerTest do
  use Web.ConnCase, async: false

  setup %{conn: conn} = meta do
    post(conn, "/register", %{"name" => "Roman", "email" => "some@mail.com", "password" => "StrongPWD!"})
    %{meta | conn: build_conn()}
  end

  describe "logged in user" do
    setup %{conn: conn} = meta do
      conn = post(conn, "/login", %{"login" => "Roman", "password" => "StrongPWD!"})
      %{meta | conn: conn}
    end

    test "redirects into last page after '/'", %{conn: conn} do
      conn = get(conn, "/")
      assert redirected_to(conn, 302) == "/chats/lobby"
    end
  
    test "see href with logout", %{conn: conn} do
      conn = get(conn, "/chats/lobby")
      assert html_response(conn, 200) =~ "/logout"
    end
  end

  test "not logged in user see hrefs with login and registration", %{conn: conn} do
    conn = get(conn, "/chats/lobby")
    assert html_response(conn, 200) =~ "/login"
    assert html_response(conn, 200) =~ "/register"      
  end
end
