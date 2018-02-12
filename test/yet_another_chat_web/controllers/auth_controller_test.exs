defmodule YetAnotherChatWeb.AuthControllerTest do
  use YetAnotherChatWeb.ConnCase, async: false

  describe "registration" do
    test "create a user with name, email and password", %{conn: conn} do
      conn = post(conn, "/register", %{"name" => "Roman", "email" => "some@mail.com", "password" => "StrongPWD!"})
      assert redirected_to(conn) === "/"
      assert get_session(conn, :current_user)

      conn = get(conn, "/users/Roman")
      assert html_response(conn, 200) =~ "Hello, Roman"
    end

    test "can't create a user without email or name or password", %{conn: conn} do
      conn = post(conn, "/register", %{"name" => "Roman"})
      refute html_response(conn, 200) =~ "Name can&#39;t be blank"
      assert html_response(conn, 200) =~ "Email can&#39;t be blank"
      assert html_response(conn, 200) =~ "Password can&#39;t be blank"
      refute get_session(conn, :current_user) 

      conn = post(conn, "/register", %{"name" => "", "email" => "", "password" => ""})
      assert html_response(conn, 200) =~ "Name can&#39;t be blank"
      assert html_response(conn, 200) =~ "Email can&#39;t be blank"
      assert html_response(conn, 200) =~ "Password can&#39;t be blank"
      refute get_session(conn, :current_user)    
    end

    test "can't create a user when name already exists", %{conn: conn} do
      conn = post(conn, "/register", %{"name" => "Roman", "email" => "some@mail.com", "password" => "StrongPWD!"})
      
      conn = post(conn, "/register", %{"name" => "Roman", "email" => "other@mail.com", "password" => "weakPWD!"})
      assert html_response(conn, 200) =~ "Name has already been taken"
    end

    test "can't create a user when email already taken", %{conn: conn} do
      conn = post(conn, "/register", %{"name" => "Roman", "email" => "some@mail.com", "password" => "StrongPWD!"})
      
      conn = post(conn, "/register", %{"name" => "Drum", "email" => "some@mail.com", "password" => "weakPWD!"})
      assert html_response(conn, 200) =~ "Email has already been taken"
    end

    test "register page contains name, email and password", %{conn: conn} do
      conn = get(conn, "/register")
      assert html_response(conn, 200) =~ "Registration"
      assert html_response(conn, 200) =~ "Name"
      assert html_response(conn, 200) =~ "Email"
      assert html_response(conn, 200) =~ "Password"    
    end
  end

  describe "logout" do
    test "logout clears session cookie", %{conn: conn} do
      conn = post(conn, "/register", %{"name" => "Roman", "email" => "some@mail.com", "password" => "StrongPWD!"})

      conn = post(conn, "/logout")
      refute get_session(conn, :current_user)
      assert redirected_to(conn, 302) == "/"
    end

    test "not logged in user can logout without failure", %{conn: conn} do
      conn = post(conn, "/logout")
      refute get_session(conn, :current_user)
    end
  end

  describe "login" do
    setup %{conn: conn} = meta do
      post(conn, "/register", %{"name" => "Roman", "email" => "some@mail.com", "password" => "StrongPWD!"})
      # I don't know why it doesn't work when I just call post("/logout").
      # It cleans conn, but conn contains :current_user in session when conn appears in Controller 
      %{meta | conn: build_conn()}
    end

    test "can login with correct name and password", %{conn: conn} do
      conn = post(conn, "/login", %{"login" => "Roman", "password" => "StrongPWD!"})
      assert get_session(conn, :current_user) === "Roman"
      assert redirected_to(conn, 302) === "/"
    end    

    test "can login with correct email and password", %{conn: conn} do
      conn = post(conn, "/login", %{"login" => "some@mail.com", "password" => "StrongPWD!"})
      assert get_session(conn, :current_user) === "Roman"
    end

    test "email is case-insensetive", %{conn: conn} do
      conn = post(conn, "/login", %{"login" => "sOmE@mail.com", "password" => "StrongPWD!"})
      assert get_session(conn, :current_user) === "Roman"
    end

    test "can not login with incorrect info", %{conn: conn} do
      conn = post(conn, "/login", %{"login" => "Namor", "password" => "StrongPWD!"})
      refute get_session(conn, :current_user)
      assert html_response(conn, 200) =~ "Invalid login or password"

      conn = post(conn, "/login", %{"login" => "Roman", "password" => "WeakPWD"})
      refute get_session(conn, :current_user)

      conn = post(conn, "/login", %{"login" => "other@mail.com", "password" => "StrongPWD!"})
      refute get_session(conn, :current_user)
    end

    test "login redirect to the previous page", %{conn: conn} do
      conn = post(conn, "/login?previous-page=/users/Name", %{"login" => "sOmE@mail.com", "password" => "StrongPWD!"})
      assert redirected_to(conn, 302) === "/users/Name"
    end

    test "login render form on get", %{conn: conn} do
      conn = get(conn, "/login")
      assert html_response(conn, 200) =~ "Login"
      assert html_response(conn, 200) =~ "Password"      
    end
  end
end
