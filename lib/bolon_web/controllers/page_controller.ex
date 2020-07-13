defmodule BolonWeb.PageController do
  use BolonWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
