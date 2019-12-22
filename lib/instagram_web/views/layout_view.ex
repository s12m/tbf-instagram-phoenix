defmodule InstagramWeb.LayoutView do
  use InstagramWeb, :view
  alias InstagramWeb.Guardian
  def current_user(conn) do
    Guardian.Plug.current_resource(conn)
  end
end
