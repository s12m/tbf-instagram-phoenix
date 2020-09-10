defmodule InstagramWeb.PostControllerTest do
  use InstagramWeb.ConnCase

  alias Instagram.Posts

  @create_attrs %{body: "some body", image: %Plug.Upload{path: "test/support/fixtures/dummy.png", filename: "dummy.png"}}
  @update_attrs %{body: "some updated body"}
  @invalid_attrs %{body: nil}

  def fixture(:post) do
    attrs = Map.put(@create_attrs, :user_id, user_fixture().id)
    {:ok, %{post_with_image: post}} = Posts.create_post(attrs)

    post
    |> Instagram.Repo.preload(:user)
  end

  def user_fixture(attrs \\ %{email: "test@example.com"}) do
    {:ok, user} =
      attrs
      |> Map.merge(%{password: "password", password_confirmation: "password"})
      |> Pow.Operations.create(otp_app: :instagram)

    user
  end

  def sign_in(conn, user \\ user_fixture()) do
    Pow.Plug.assign_current_user(conn, user, otp_app: :instagram)
  end

  describe "index" do
    test "lists all posts", %{conn: conn} do
      conn =
        conn
        |> sign_in()
        |> get(Routes.post_path(conn, :index))

      assert html_response(conn, 200) =~ "Your posts"
    end

    test "redirects to /session/new when not signed in", %{conn: conn} do
      path = Routes.post_path(conn, :index)
      conn = get(conn, path)
      assert redirected_to(conn) == Routes.pow_session_path(conn, :new, request_path: path)
    end
  end

  describe "new post" do
    test "renders form", %{conn: conn} do
      conn = 
        conn
        |> sign_in()
        |> get(Routes.post_path(conn, :new))

      assert html_response(conn, 200) =~ "New Post"
    end

    test "redirects to /session/new when not signed in", %{conn: conn} do
      path = Routes.post_path(conn, :new)
      conn = get(conn, path)
      assert redirected_to(conn) == Routes.pow_session_path(conn, :new, request_path: path)
    end
  end

  describe "create post" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = 
        conn
        |> sign_in()
        |> post(Routes.post_path(conn, :create), post: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.post_path(conn, :show, id)

      conn = get(conn, Routes.post_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Post"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = 
        conn
        |> sign_in()
        |> post(Routes.post_path(conn, :create), post: @invalid_attrs)

      assert html_response(conn, 200) =~ "New Post"
    end
  end

  describe "edit post" do
    setup [:create_post]

    test "renders form for editing chosen post", %{conn: conn, post: post} do
      conn = 
        conn
        |> sign_in(post.user)
        |> get(Routes.post_path(conn, :edit, post))

      assert html_response(conn, 200) =~ "Edit Post"
    end

    test "redirects to /session/new when not signed in", %{conn: conn, post: post} do
      path = Routes.post_path(conn, :edit, post)
      conn = get(conn, path)
      assert redirected_to(conn) == Routes.pow_session_path(conn, :new, request_path: path)
    end
  end

  describe "update post" do
    setup [:create_post]

    test "redirects when data is valid", %{conn: conn, post: post} do
      conn = 
        conn
        |> sign_in(post.user)
        |> put(Routes.post_path(conn, :update, post), post: @update_attrs)

      assert redirected_to(conn) == Routes.post_path(conn, :show, post)

      conn = get(conn, Routes.post_path(conn, :show, post))
      assert html_response(conn, 200) =~ "some updated body"
    end

    test "renders errors when data is invalid", %{conn: conn, post: post} do
      conn = 
        conn
        |> sign_in(post.user)
        |> put(Routes.post_path(conn, :update, post), post: @invalid_attrs)

      assert html_response(conn, 200) =~ "Edit Post"
    end
  end

  describe "delete post" do
    setup [:create_post]

    test "deletes chosen post", %{conn: conn, post: post} do
      conn = 
        conn
        |> sign_in(post.user)
        |> delete(Routes.post_path(conn, :delete, post))

      assert redirected_to(conn) == Routes.post_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.post_path(conn, :show, post))
      end
    end
  end

  defp create_post(_) do
    post = fixture(:post)
    %{post: post}
  end
end
