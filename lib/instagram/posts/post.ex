defmodule Instagram.Posts.Post do
  use Ecto.Schema
  use Arc.Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :body, :string
    field :image, Instagram.ImageUploader.Type
    field :directory, :string

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:body])
    |> put_directory()
    |> cast_attachments(attrs, [:image])
    |> validate_required([:body, :image])
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
