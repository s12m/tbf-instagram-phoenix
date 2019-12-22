defmodule InstagramWeb.RegistrationController do
  use InstagramWeb, :controller
  import InstagramWeb.Guardian.Plug

  alias Instagram.Accounts
  alias Instagram.Accounts.User

  def new(conn, _) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        url = get_session(conn, :user_return_to) || Routes.post_path(conn, :index)
        conn
        |> sign_in(user)
        |> delete_session(:user_return_to)
        |> put_flash(:info, "Registration successfully.")
        |> redirect(external: url)
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end