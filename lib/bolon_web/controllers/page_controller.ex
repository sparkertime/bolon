defmodule BolonWeb.PageController do
  use BolonWeb, :controller

  def index(conn, _params) do
    redirect(conn, to: "/market")
  end
end