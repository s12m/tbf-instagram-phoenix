defmodule Instagram.Repo.Migrations.AddImageToPosts do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :directory, :string
      add :image, :string
    end
  end
end
