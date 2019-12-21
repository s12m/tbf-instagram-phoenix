defmodule InstagramWeb.RegistrationController do
  use InstagramWeb, :controller

  alias Instagram.Guardian
  alias Instagram.Accounts
  alias Instagram.Accounts.User

  def new(conn, _) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> Guardian.Plug.sign_in(user)
        |> put_flash(:info, "Registration successfully.")
        |> redirect(to: Routes.post_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end