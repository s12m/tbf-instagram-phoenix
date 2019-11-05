defmodule InstagramWeb.PageController do
  use InstagramWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
