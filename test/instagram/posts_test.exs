defmodule Instagram.PostsTest do
  use Instagram.DataCase

  alias Instagram.Posts

  describe "posts" do
    alias Instagram.Posts.Post

    @valid_attrs %{body: "some body", image: %Plug.Upload{path: "test/support/fixtures/dummy.png", filename: "dummy.png"}}
    @update_attrs %{body: "some updated body"}
    @invalid_attrs %{body: nil}
    @invalid_image_attrs %{body: "some body", image: nil}

    def post_fixture(attrs \\ %{user_id: user_fixture().id}) do
      {:ok, %{post_with_image: post}} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Posts.create_post()

      post
      |> Repo.preload(:user)
    end

    def user_fixture(attrs \\ %{email: "test@example.com"}) do
      {:ok, user} =
        attrs
        |> Map.merge(%{password: "password", password_confirmation: "password"})
        |> Pow.Operations.create(otp_app: :instagram)

      user
    end

    test "list_posts/0 returns all posts" do
      post = post_fixture()
      assert Posts.list_posts() == [post]
    end

    test "list_posts/1 returns the list of posts created by the user" do
      post = post_fixture()
      other_user = user_fixture(%{email: "other@example.com"})
      _ = post_fixture(%{user_id: other_user.id})
      assert Posts.list_posts(post.user) == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert Posts.get_post!(post.id) == post
    end

    test "get_post!/2 returns the post with given id when created by the user" do
      post = post_fixture()
      assert Posts.get_post!(post.user, post.id) |> Repo.preload(:user) == post
    end

    test "get_post!/2 raise an error when created by the other user" do
      user = user_fixture()
      other_user = user_fixture(%{email: "other@example.com"})
      other_post = post_fixture(%{user_id: other_user.id})
      assert_raise Ecto.NoResultsError, fn -> Posts.get_post!(user, other_post.id) end
    end

    test "create_post/1 with valid data creates a post" do
      user = user_fixture()
      attrs = Map.put(@valid_attrs, :user_id, user.id)
      assert {:ok, %{post_with_image: %Post{} = post}} = Posts.create_post(attrs)
      assert post.body == "some body"
      assert post.image
      assert post.user_id == user.id
    end

    test "create_post/1 with invalid data returns error changeset" do
      user = user_fixture()
      attrs = Map.put(@invalid_attrs, :user_id, user.id)
      assert {:error, :post, %Ecto.Changeset{} = changeset, _} = Posts.create_post(attrs)
      assert %{body: ["can't be blank"]} = errors_on(changeset)
    end

    test "create_post/1 with invalid image data returns error changeset" do
      user = user_fixture()
      attrs = Map.put(@invalid_image_attrs, :user_id, user.id)
      assert {:error, :post_with_image, %Ecto.Changeset{} = changeset, _} = Posts.create_post(attrs)
      assert %{image: ["can't be blank"]} = errors_on(changeset)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()
      assert {:ok, %Post{} = post} = Posts.update_post(post, @update_attrs)
      assert post.body == "some updated body"
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{} = changeset} = Posts.update_post(post, @invalid_attrs)
      assert post == Posts.get_post!(post.id)
      assert %{body: ["can't be blank"]} = errors_on(changeset)
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
