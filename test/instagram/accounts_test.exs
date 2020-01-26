defmodule Instagram.AccountsTest do
  use Instagram.DataCase

  alias Instagram.Accounts

  describe "user" do
    alias Instagram.Accounts.User

    @valid_attrs %{email: "some@example.com", password: "password", password_confirmation: "password"}
    @update_attrs %{email: "updated@example.com"}
    @invalid_attrs %{email: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "authenticate_user/2 with valid data returns authenticated user" do
      _user = user_fixture()
      assert {:ok, user} = Accounts.authenticate_user("some@example.com", "password")
      assert user.email == "some@example.com"
    end

    test "authenticate_user/2 with invalid data returns error" do
      _user = user_fixture()
      assert {:error, :invalid_credentials} = Accounts.authenticate_user("some@example.com", "incorrect_password")
    end

    test "list_user/0 returns all user" do
      _user = user_fixture()
      assert [%User{} = user] = Accounts.list_user()
      assert user.email == "some@example.com"
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert user = Accounts.get_user!(user.id)
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.email == "some@example.com"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
      assert user.email == "updated@example.com"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user = Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
