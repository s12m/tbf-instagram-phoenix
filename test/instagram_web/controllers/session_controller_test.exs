defmodule InstagramWeb.SessionControllerTest do
  use InstagramWeb.ConnCase
  import InstagramWeb.Guardian.Plug

  @create_attrs %{email: "some@example.com", password: "password"}
  @invalid_attrs %{email: "some@example.com", password: "incorrect_password"}

  def user_fixture do
    {:ok, user} = Instagram.Accounts.create_user(Map.put(@create_attrs, :password_confirmation, "password"))

    user
  end

  describe "new session" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.session_path(conn, :new))
      assert html_response(conn, 200) =~ "Login"
    end

    test "redirects to posts index when logged in", %{conn: conn} do
      user = user_fixture()
      conn =
        conn
        |> sign_in(user)
        |> get(Routes.session_path(conn, :new))
      assert redirected_to(conn) == Routes.post_path(conn, :index)
    end
  end

  describe "create session" do
    test "redirects to posts list when data is valid", %{conn: conn} do
      _user = user_fixture()
      conn = post(conn, Routes.session_path(conn, :create), user: @create_attrs)

      assert redirected_to(conn) == Routes.post_path(conn, :index)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      _user = user_fixture()
      conn = post(conn, Routes.session_path(conn, :create), user: @invalid_attrs)

      assert html_response(conn, 200) =~ "Invalid email or password."
    end
  end
end