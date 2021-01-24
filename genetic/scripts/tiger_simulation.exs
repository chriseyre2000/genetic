defmodule TigerSimulation do
  @behaviour Problem
  alias Types.Chromosome

  @impl true
  def genotype do
    genes = for _ <- 1..8, do: Enum.random(0..1)
    %Chromosome{genes: genes, size: 8}
  end

  @impl true
  def fitness_function(chromosome) do
    tropic_scores = [0.0, 3.0, 2.0, 1.0, 0.5, 1.0, -1.0, 0.0]
    _tundra_scores = [1.0, 3.0, -2.0, -1.0, 0.5, 2.0, 1.0, 0.0]
    traits = chromosome.genes

    traits
    |> Enum.zip(tropic_scores)
    |> Enum.map(fn {t, s} -> t * s end)
    |> Enum.sum()
  end

  @impl true
  def terminate?(_population, generation) do
    generation == 2
  end

  def average_tiger(population) do
    genes = Enum.map(population, & &1.genes)
    fitness = Enum.map(population, & &1.fitness)
    ages = Enum.map(population, & &1.age)
    num_tigers = length(population)
    avg_fitness = Enum.sum(fitness) / num_tigers
    avg_age = Enum.sum(ages) / num_tigers
    avg_genes = genes
      |> Enum.zip()
      |> Enum.map( &Tuple.to_list/1)
      |> Enum.map( &Enum.sum(&1) / num_tigers )
    %Chromosome{genes: avg_genes, age: avg_age, fitness: avg_fitness}
  end
end

soln = Genetic.run(TigerSimulation,
    mutation_type: &Toolbox.Mutation.scramble/1,
    crossover_type: &Toolbox.Crossover.single_point/2,
    reinsertion_strategy: &Toolbox.Reinsertion.uniform/3,
    population_size: 5,
    selection_rate: 0.9,
    mutation_rate: 0.1)

IO.write("\n")
IO.inspect(soln)

# geneology = Utilities.Geneology.get_tree()

# {:ok, dot} = Graph.Serializers.DOT.serialize(geneology)
# {:ok, dotfile} = File.open("tiger_simulation.dot", [:write])
# :ok = IO.binwrite(dotfile, dot)

# IO.inspect(Graph.vertices(geneology))
