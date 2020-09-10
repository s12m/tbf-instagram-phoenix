defmodule InstagramWeb.PageControllerTest do
  use InstagramWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "All posts"
  end
end
