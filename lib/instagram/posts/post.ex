defmodule Instagram.Posts.Post do
  use Ecto.Schema
  use Arc.Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false

  alias Instagram.Accounts.User

  schema "posts" do
    field :body, :string
    field :image, Instagram.ImageUploader.Type
    field :directory, :string
    belongs_to :user, User

    timestamps()
  end

  @doc """
  Returns query filtered by user.
  """
  def filter_by_user(query, %User{id: user_id}), do: from p in query, where: p.user_id == ^user_id

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:body, :user_id])
    |> put_directory()
    |> cast_attachments(attrs, [:image])
    |> validate_required([:body, :image, :user_id])
  end

  defp put_directory(changeset) do
    case Ecto.get_meta(changeset.data, :state) do
      :built ->
        put_change(changeset, :directory, Instagram.generate_token)
      _ ->
        changeset
    end
  end
end
