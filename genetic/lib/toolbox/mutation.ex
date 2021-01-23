defmodule Toolbox.Mutation do
  use Bitwise
  alias Types.Chromosome

  def flip(chromosome) do
    genes =
      chromosome.genes
      |> Enum.map(& &1 ^^^ 1)

    %Chromosome{chromosome | genes: genes}
  end

  def flip(chromosome, p) do
    genes =
    chromosome.genes
    |> Enum.map( fn g ->
      if :rand.uniform < p do
        g ^^^ 1
      else
        g
      end
    end)
    %Chromosome{chromosome | genes: genes}
  end

  def scramble(chromosome) do
    genes =
      chromosome.genes
      |> Enum.shuffle()

    %Chromosome{chromosome | genes: genes}
  end

  def scramble(chromosome, n) do
    start = :rand.uniform(n - 1)
    {lo, hi} =
      if start + n >= chromosome.size do
        {start - n, start}
      else
        {start, start + n}
      end

    head = Enum.slice(chromosome.genes, 0, lo)
    mid = Enum.slice(chromosome.genes, lo, hi)
    tail = Enum.slice(chromosome.genes, hi, chromosome.size)

    %Chromosome{chromosome | genes: head ++ Enum.shuffle(mid) ++ tail}
  end

  def gaussian(chromosome) do
    mu = Enum.sum(chromosome.genes)
    sigma =
      chromosome.genes
      |> Enum.map(fn x -> (mu - x) * (mu - x) end)
      |> Enum.sum()
      |> Kernel./(length(chromosome.genes))

    genes =
      chromosome.genes
      |> Enum.map(fn _ -> :rand.normal(mu, sigma) end)

      %Chromosome{chromosome | genes: genes}
  end

end
