defmodule BolonWeb.PageControllerTest do
  use BolonWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Bolon"
  end
end
