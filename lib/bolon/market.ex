defmodule Bolon.Market do
  import Bolon.Random
  import Ecto.Query, only: [from: 2]
  alias Bolon.Repo
  alias Bolon.Price

  @items %{
    common: [
      "10ft chain",
      "10ft pole",
      "50ft rope",
      "arrows / ammunition (Ud8)",
      "backpacks / sacks",
      "candles (Ud4)",
      "canvas / cloth",
      "chalk (Ud6)",
      "climbing gear",
      "commoner’s garb",
      "crowbar & laborer’s tools",
      "flasks / wineskin",
      "flint & steel",
      "garlic / herbs (Ud6)",
      "grappling hook",
      "ink & quill (Ud6)",
      "iron spikes (Ud6)",
      "jug of oil (Ud6)",
      "light bow",
      "one-handed weapon",
      "parchment",
      "pots / cooking utensils",
      "rations - dried (Ud8)",
      "small tent",
      "torches (Ud6)",
      "wax (Ud4)",
      "whistle",
    ],
    rare: [
      "caltrops (Ud6)",
      "crossbow",
      "custom or exotic weapon",
      "disguise",
      "heavy bow",
      "holy symbol",
      "holy water (Ud6)",
      "lock",
      "musical instrument",
      "thieves’ toolkit",
      "two-handed weapon",
      "well-made clothing",
    ],
    exotic: [
      "accurate map",
      "alchemical ingredients (Ud4)",
      "fine jewelery",
      "materials for alchemy and magic",
      "poison (Ud6)",
      "sextant & navigation tools",
    ]
  }

  def armors do
    [
      {"helmet", random_common_price()},
      {"shield", random_common_price()},
      {"cloth armor (AV1)", random_common_price()},
      {"leather armor (AV2)", random_rare_price() + random_rare_price()},
      {"chain mail (AV3)", random_exotic_price() + random_exotic_price() + random_exotic_price()},
      {"plate armor (AV4)", random_exotic_price() + random_exotic_price() + random_exotic_price() + random_exotic_price()},
      {"repair one Broken Cloth Armor Die", random_common_price()},
      {"repair one Broken Leather Armor Die", random_rare_price()},
      {"repair one Broken Chain Mail Armor Die", random_exotic_price()},
      {"repair one Broken Plate Armor Die", random_exotic_price()},
    ]
  end

  def common_prices do
    Repo.all(from p in Price, where: p.type == "common", order_by: p.display_order)
  end

  def rare_prices do
    Repo.all(from p in Price, where: p.type == "rare", order_by: p.display_order)
  end

  def exotic_prices do
    Repo.all(from p in Price, where: p.type == "exotic", order_by: p.display_order)
  end

  def armor_prices do
    Repo.all(from p in Price, where: p.type == "armor", order_by: p.display_order)
  end

  @day_in_seconds 24 * 60 * 60
  def refresh_prices do
    days_since_monday = 1 - Date.day_of_week(Date.utc_today())
    most_recent_monday =
      DateTime.utc_now()
      |> DateTime.add(days_since_monday * @day_in_seconds, :second)
      |> DateTime.to_naive()
    cutoff = %NaiveDateTime{most_recent_monday | hour: 0, minute: 0, second: 0, microsecond: 0}
    latest_price = Repo.one(from p in Price, where: p.inserted_at >= ^cutoff, limit: 1)

    if latest_price == nil do
      generate_new_prices()
    end
  end

  defp generate_new_prices do
    Bolon.Repo.delete_all(Price)

    pricing_fns = %{
      common: &random_common_price/0,
      rare: &random_rare_price/0,
      exotic: &random_exotic_price/0
    }

    for type <- [:common, :rare, :exotic] do
      for {item, order} <- Enum.with_index(Map.get(@items, type)) do
        pricing_fn = Map.get(pricing_fns, type)
        %Price{
          item: item,
          type: Atom.to_string(type),
          display_order: order,
          price: pricing_fn.()
        } |> Repo.insert
      end
    end
    for {{item, price}, order} <- Enum.with_index(armors()) do
      %Price{
        item: item,
        type: "armor",
        display_order: order,
        price: price
      } |> Repo.insert
    end
  end

  def random_common_price do
    roll(8)
  end

  def random_rare_price do
    (roll(8) + roll(8)) * 5
  end

  def random_exotic_price do
    (roll(8) + roll(8) + roll(8) + roll(8)) * 10
  end
end