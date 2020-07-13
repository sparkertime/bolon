defmodule Bolon.Random do
  def roll(die_size) do
    :rand.uniform(die_size)
  end
end