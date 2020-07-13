defmodule BolonWeb.MarketView do
  use BolonWeb, :view

  @price_thresholds %{
    "common" => {1,8},
    "rare" => {20,70},
    "exotic" => {120,240},
  }

  def is_good_deal(type, price) do
    {low, _} = Map.get(@price_thresholds, type)
    price <= low
  end

  def is_bad_deal(type, price) do
    {_, high} = Map.get(@price_thresholds, type)
    price >= high
  end
end