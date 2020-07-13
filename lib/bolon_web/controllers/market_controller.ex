defmodule BolonWeb.MarketController do
  use BolonWeb, :controller

  def index(conn, _params) do
    Bolon.Market.refresh_prices()

    render(conn, :index,
      common_prices: Bolon.Market.common_prices(),
      rare_prices: Bolon.Market.rare_prices(),
      exotic_prices: Bolon.Market.exotic_prices(),
      armor_prices: Bolon.Market.armor_prices(),
    )
  end
end
