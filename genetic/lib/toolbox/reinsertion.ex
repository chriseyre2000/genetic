defmodule Toolbox.Reinsertion do

  alias Types.Chromosome
  def pure(_parents, offspring, _leftovers), do: offspring

  def elitist(parents, offspring, leftovers, survival_rate) do
    old = parents ++ leftovers
    n = floor(length(old) * survival_rate)
    survivors =
      old
      |> Enum.sort_by(fn f -> f.fitness end, &>=/2)
      |> Enum.take(n)
    offspring ++ survivors
  end

  def uniform(parents, offspring, leftovers) do
    survival_rate = 0.05

    old = parents ++ leftovers
    n = floor(length(old) * survival_rate)
    survivors =
      old
      |> Enum.take_random(n)
    offspring ++ survivors
  end
end
