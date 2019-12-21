defmodule Instagram.Guardian.ErrorHandler do
  use InstagramWeb, :controller

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {type, _}, _) do
    case type do
      :unauthenticated ->
        conn
        |> put_flash(:error, "Please login.")
        |> redirect(to: Routes.session_path(conn, :new))
      :already_authenticated ->
        conn
        |> put_flash(:error, "Already authenticated.")
        |> redirect(to: Routes.post_path(conn, :index))
    end
  end
end