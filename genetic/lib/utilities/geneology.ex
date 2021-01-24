defmodule Utilities.Geneology do
  use GenServer

  def init(_opts) do
    {:ok, Graph.new()}
  end

  def handle_cast({:add_chromosomes, chromosomes}, geneology) do
    {:noreply, Graph.add_vertices(geneology, chromosomes)}
  end

  # Child is a mutant of parent
  def handle_cast({:add_choromosome, parent, child}, geneology) do
    new_geneology =
     geneology
     |> Graph.add_edge(parent, child)
    {:noreply, new_geneology}
  end

  # Child is a crossover of parent
  def handle_cast({:add_choromosome, parent_a, parent_b, child}, geneology) do
    new_geneology =
     geneology
     |> Graph.add_edge(parent_a, child)
     |> Graph.add_edge(parent_b, child)
    {:noreply, new_geneology}
  end

  def handle_call(:get_tree, _, geneology) do
    {:reply, geneology, geneology}
  end

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def add_chromosomes(chromosomes) do
    GenServer.cast(__MODULE__, {:add_chromosomes, chromosomes})
  end

  def add_chromosome(parent, child) do
    GenServer.cast(__MODULE__, {:add_chromosome, parent, child})
  end

  def add_chromosome(parent_a, parent_b, child) do
    GenServer.cast(__MODULE__, {:add_chromosome, parent_a, parent_b, child})
  end

  def get_tree do
    GenServer.call(__MODULE__, :get_tree)
  end
end
