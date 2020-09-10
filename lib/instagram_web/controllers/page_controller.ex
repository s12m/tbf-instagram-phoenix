defmodule InstagramWeb.PageController do
  use InstagramWeb, :controller

  def index(conn, _params) do
    posts = Instagram.Posts.list_posts
    render(conn, "index.html", posts: posts)
  end
end
