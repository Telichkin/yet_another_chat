defmodule Web.UserControllerTest do
    use Web.ConnCase, async: false

    test "anon can't open user page", %{conn: conn} do
        conn = get(conn, "/users/Roman")
        assert html_response(conn, 403) =~ "Oops... You should be logged in"
        refute html_response(conn, 403) =~ "Hello, Roman"
    end

    test "other user's page can't be oppened", %{conn: conn} do
        conn = post(conn, "/register", %{"name" => "Roman", "email" => "some@mail.com", "password" => "StrongPWD!"})
        conn = get(conn, "/users/Omar")
        assert html_response(conn, 403) =~ "Oops... Looks like it&#39;s not your page"
    end
end