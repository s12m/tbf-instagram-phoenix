defmodule Instagram.Posts do
  @moduledoc """
  The Posts context.
  """

  import Ecto.Query, warn: false
  alias Instagram.Repo

  alias Instagram.Posts.Post
  alias Instagram.Users.User

  @doc """
  Returns the list of posts.

  ## Examples

      iex> list_posts()
      [%Post{}, ...]

  """
  def list_posts do
    Repo.all(Post)
    |> Repo.preload(:user)
  end

  @doc """
  Returns the list of posts by the user.
  """
  def list_posts(%User{} = user) do
    Repo.all(Post.filter_by_user(Post, user))
    |> Repo.preload(:user)
  end

  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

      iex> get_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post!(id), do: Repo.get!(Post, id) |> Repo.preload(:user)

  @doc """
  Gets a single post created by the user.
  """
  def get_post!(%User{} = user, id) do
    Post
    |> Post.filter_by_user(user)
    |> Repo.get!(id)
  end

  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%{field: value})
      {:ok, %Post{}}

      iex> create_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(attrs \\ %{}) do
    Ecto.Multi.new
    |> Ecto.Multi.insert(:post, Post.changeset(%Post{}, attrs))
    |> Ecto.Multi.update(:post_with_image, &Post.image_changeset(&1.post, attrs))
    |> Repo.transaction()
  end

  @doc """
  Updates a post.

  ## Examples

      iex> update_post(post, %{field: new_value})
      {:ok, %Post{}}

      iex> update_post(post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post(%Post{} = post, attrs) do
    changeset = Ecto.Changeset.merge(
      Post.changeset(post, attrs),
      Post.image_changeset(post, attrs)
    )
    Repo.update(changeset)
  end

  @doc """
  Deletes a post.

  ## Examples

      iex> delete_post(post)
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

      iex> change_post(post)
      %Ecto.Changeset{data: %Post{}}

  """
  def change_post(%Post{} = post, attrs \\ %{}) do
    Post.changeset(post, attrs)
  end
end
