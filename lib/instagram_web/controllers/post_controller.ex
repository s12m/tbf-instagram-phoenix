defmodule InstagramWeb.PostController do
  use InstagramWeb, :controller
  import Guardian.Plug

  alias Instagram.Repo
  alias Instagram.Posts
  alias Instagram.Posts.Post

  def index(conn, _params) do
    posts = Posts.list_posts(current_resource(conn))
    render(conn, "index.html", posts: posts)
  end

  def new(conn, _params) do
    changeset = Posts.change_post(%Post{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"post" => post_params}) do
    case Posts.create_post(Map.put(post_params, "user_id", current_resource(conn).id)) do
      {:ok, %{post_with_image: post}} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: Routes.post_path(conn, :show, post))

      {:error, _, %Ecto.Changeset{} = changeset, _} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    post = 
      id
      |> Posts.get_post!()
      |> Repo.preload(:user)
    render(conn, "show.html", post: post)
  end

  def edit(conn, %{"id" => id}) do
    post = Posts.get_post!(id, current_resource(conn))
    changeset = Posts.change_post(post)
    render(conn, "edit.html", post: post, changeset: changeset)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Posts.get_post!(id, current_resource(conn))

    case Posts.update_post(post, post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: Routes.post_path(conn, :show, post))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", post: post, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Posts.get_post!(id, current_resource(conn))
    {:ok, _post} = Posts.delete_post(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: Routes.post_path(conn, :index))
  end
end
