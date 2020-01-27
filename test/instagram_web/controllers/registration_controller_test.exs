defmodule InstagramWeb.RegistrationControllerTest do
  use InstagramWeb.ConnCase
  import InstagramWeb.Guardian.Plug

  @create_attrs %{email: "some@example.com", password: "password", password_confirmation: "password"}
  @invalid_attrs %{email: "some@example.com", password: "password", password_confirmation: "incorrect_password"}

  describe "new registration" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.registration_path(conn, :new))
      assert html_response(conn, 200) =~ "Register"
    end

    test "redirects to posts index when logged in", %{conn: conn} do
      {:ok, user} = Instagram.Accounts.create_user(@create_attrs)
      conn =
        conn
        |> sign_in(user)
        |> get(Routes.registration_path(conn, :new))
      assert redirected_to(conn) == Routes.post_path(conn, :index)
    end
  end

  describe "create user" do
    test "redirects to posts list when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.registration_path(conn, :create), user: @create_attrs)

      assert redirected_to(conn) == Routes.post_path(conn, :index)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.registration_path(conn, :create), user: @invalid_attrs)

      assert html_response(conn, 200) =~ "does not match confirmation"
    end
  end
end