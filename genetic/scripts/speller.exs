defmodule Speller do
  @behaviour Problem
  alias Types.Chromosome

  @impl true
  def genotype do
    genes = Stream.repeatedly(fn -> Enum.random(?a..?z) end)
      |> Enum.take(7)
    %Chromosome{genes: genes, size: 7}
  end

  @impl true
  def fitness_function(chromosome) do
    target = "fishing"
    guess = List.to_string(chromosome.genes)
    String.jaro_distance(target, guess)
  end

  @impl true
  def terminate?([best| _]) do
    best.fitness == 1
  end
end

soln = Genetic.run(Speller)

IO.write("\n")
IO.inspect(soln)
