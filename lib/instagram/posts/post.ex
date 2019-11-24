defmodule Instagram.Posts.Post do
  use Ecto.Schema
  use Arc.Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :body, :string
    field :image, Instagram.ImageUploader.Type

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:body])
    |> cast_attachments(attrs, [:image])
    |> validate_required([:body, :image])
  end
end
