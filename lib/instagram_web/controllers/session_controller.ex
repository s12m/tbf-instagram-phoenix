defmodule InstagramWeb.SessionController do
  use InstagramWeb, :controller
  import InstagramWeb.Guardian.Plug

  alias Instagram.Accounts
  alias Instagram.Accounts.User

  def new(conn, _) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => %{"email" => email, "password" => password}}) do
    case Accounts.authenticate_user(email, password) do
      {:ok, user} ->
        url = get_session(conn, :user_return_to) || Routes.post_path(conn, :index)
        conn
        |> sign_in(user)
        |> delete_session(:user_return_to)
        |> put_flash(:info, "Login successfully.")
        |> redirect(external: url)
      {:error, :invalid_credentials} ->
        conn
        |> put_flash(:error, "Invalid email or password.") 
        |> new(%{})
    end
  end

  def destroy(conn, _) do
    conn
    |> sign_out()
    |> put_flash(:info, "Logout successfully.")
    |> redirect(to: Routes.page_path(conn, :index))
  end
end