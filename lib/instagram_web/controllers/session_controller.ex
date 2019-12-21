defmodule InstagramWeb.SessionController do
  use InstagramWeb, :controller

  alias Instagram.Guardian
  alias Instagram.Accounts
  alias Instagram.Accounts.User

  def new(conn, _) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => %{"email" => email, "password" => password}}) do
    case Accounts.authenticate_user(email, password) do
      {:ok, user} ->
        conn
        |> Guardian.Plug.sign_in(user)
        |> put_flash(:info, "Login successfully.")
        |> redirect(to: Routes.post_path(conn, :index))
      {:error, :invalid_credentials} ->
        conn
        |> put_flash(:error, "Invalid email or password.") 
        |> new(%{})
    end
  end

  def destroy(conn, _) do
    conn
    |> Guardian.Plug.sign_out()
    |> put_flash(:info, "Logout successfully.")
    |> redirect(to: Routes.page_path(conn, :index))
  end
end