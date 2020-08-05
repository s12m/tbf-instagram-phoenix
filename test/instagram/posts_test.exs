defmodule Instagram.PostsTest do
  use Instagram.DataCase

  alias Instagram.Posts

  describe "posts" do
    alias Instagram.Posts.Post

    @valid_attrs %{body: "some body", image: %Plug.Upload{path: "test/support/dummy.png", filename: "dummy.png"}}
    @update_attrs %{body: "some updated body"}
    @invalid_attrs %{body: nil}
    @invalid_image_attrs %{body: "some body", image: nil}

    def post_fixture(attrs \\ %{}) do
      {:ok, %{post_with_image: post}} =
        attrs
        |> Enum.into(@valid_attrs)
        |> put_default_user_id()
        |> Posts.create_post()

      post
    end

    def user_fixture(email \\ "test@example.com") do
      {:ok, user} = Instagram.Accounts.create_user(%{
        email: email,
        password: "password",
        password_confirmation: "password"
      })

      user
    end

    def put_default_user_id(%{user_id: _} = attrs), do: attrs
    def put_default_user_id(attrs), do: Map.put(attrs, :user_id, user_fixture().id)

    test "list_posts/0 returns all posts" do
      post = post_fixture() |> Repo.preload(:user)
      other_post = post_fixture(user_id: user_fixture("other@example.com").id) |> Repo.preload(:user)
      assert Posts.list_posts() == [post, other_post]
    end

    test "list_posts/1 returns user's posts" do
      post = post_fixture() |> Repo.preload(:user)
      _other_post = post_fixture(user_id: user_fixture("other@example.com").id) |> Repo.preload(:user)
      assert Posts.list_posts(post.user) == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert Posts.get_post!(post.id) == post
    end

    test "get_post!/2 returns user's post with given id" do
      post = post_fixture() |> Repo.preload(:user)
      other_user = user_fixture("other@example.com")
      assert Posts.get_post!(post.id, post.user) |> Repo.preload(:user) == post
      assert_raise Ecto.NoResultsError, fn -> Posts.get_post!(post.id, other_user) end
    end

    test "create_post/1 with valid data creates a post" do
      assert {:ok, %{post_with_image: %Post{} = post}} = Posts.create_post(Map.put(@valid_attrs, :user_id, user_fixture().id))
      assert post.body == "some body"
      assert post.image
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, :post, %Ecto.Changeset{}, _} = Posts.create_post(@invalid_attrs)
    end

    test "create_post/1 with invalid image data returns error changeset" do
      assert {:error, :post_with_image, %Ecto.Changeset{}, _} = Posts.create_post(Map.put(@invalid_image_attrs, :user_id, user_fixture().id))
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()
      assert {:ok, %Post{} = post} = Posts.update_post(post, @update_attrs)
      assert post.body == "some updated body"
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = Posts.update_post(post, @invalid_attrs)
      assert post == Posts.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = Posts.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Posts.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = Posts.change_post(post)
    end
  end
end
