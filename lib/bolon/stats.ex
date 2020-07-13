defmodule Bolon.Stats do
  @stats ["STR", "WIS", "DEX", "INT", "CON", "CHA"]
  @prior_stats [
    {"DEX", "STR"},
    {"CON", "DEX"},
    {"WIS", "CON"},
    {"INT", "WIS"},
    {"CHA", "INT"},
  ]
  def roll_stats do
    generate_random_stat_map()
    |> trim_from_prior
    |> stats_summary
  end

  defp stats_summary(stat_map) do
    %{
      fields: fields(stat_map),
      total: total(stat_map)
    }
  end

  defp total(stat_map) do
    Enum.reduce(stat_map, 0, fn
      {_, :fixed}, acc -> acc + 7
      {_, values}, acc -> acc + Enum.sum(values)
    end)
  end

  defp fields(stat_map) do
    Enum.map(@stats, fn stat ->
      case stat_map[stat] do
        :fixed -> "*#{stat}*: 7 [prior result was 14+]"
        values ->
          sum = Enum.sum(values)
          list = Enum.join(values, ", ")
          "*#{stat}*: #{sum} [#{list}]"
      end
    end)
  end

  defp trim_from_prior(stat_map) do
    Enum.reduce(@prior_stats, stat_map, fn {stat, prior_stat}, acc ->
      Map.put(acc, stat,
        if(acc[prior_stat] == :fixed || Enum.sum(acc[prior_stat]) < 14) do
          acc[stat]
        else
          :fixed
        end
      )
    end)
  end

  defp generate_random_stat_map do
    Enum.reduce(@stats, %{}, fn stat, acc ->
      Map.put(acc, stat, [:rand.uniform(6), :rand.uniform(6), :rand.uniform(6)])
    end)
  end
end