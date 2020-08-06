defmodule Instagram.Repo.Migrations.RemoveDirectoryFromPosts do
  use Ecto.Migration

  def up do
    alter table(:posts) do
      remove :directory
    end
  end

  def down do
    alter table(:posts) do
      add :directory, :string
    end
  end
end
