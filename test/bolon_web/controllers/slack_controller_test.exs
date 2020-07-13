defmodule BolonWeb.SlackControllerTest do
  use BolonWeb.ConnCase

  test "POST /slack/rollstats", %{conn: conn} do
    conn = post(conn, "/slack/rollstats", %{
      "user_id" => 123,
      "text" => "Marko"
    })
    body = json_response(conn, 200)
    # assert body == %{}
    assert "in_channel" == body["response_type"]
  end
end