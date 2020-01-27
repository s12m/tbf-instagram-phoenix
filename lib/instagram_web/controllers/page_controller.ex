defmodule InstagramWeb.PageController do
  use InstagramWeb, :controller

  alias Instagram.Posts

  def index(conn, _params) do
    posts = Posts.list_posts()
    render(conn, "index.html", posts: posts)
  end
end
