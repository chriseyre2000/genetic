defmodule Toolbox.Crossover do
  alias Types.Chromosome

  def order_one(p1, p2) do
    lim = Enum.count(p1.genes) - 1
    # Get the random range
    {i1, i2} =
      [:rand.uniform(lim), :rand.uniform(lim)]
      |> Enum.sort()
      |> List.to_tuple()

    # p2 contribution
    slice1 = Enum.slice(p1.genes, i1..i2)
    slice1_set = MapSet.new(slice1)
    p2_contrib = Enum.reject(p2.genes, &MapSet.member?(slice1_set, &1))
    {head1, tail1} = Enum.split(p2_contrib, i1)

    # p1 contribution
    slice2 = Enum.slice(p2.genes, i1..i2)
    slice2_set = MapSet.new(slice2)
    p1_contrib = Enum.reject(p1.genes, &MapSet.member?(slice2_set, &1))
    {head2, tail2} = Enum.split(p1_contrib, i1)

    # Make and return
    {c1, c2} = {head1 ++ slice1 ++ tail1, head2 ++ slice2 ++ tail2}

    {
      %Chromosome{genes: c1, size: p1.size},
      %Chromosome{genes: c2, size: p2.size},
    }
  end

  def single_point(p1, p2) do
    cx_point = :rand.uniform(p1.size)
    {p1_head, p1_tail} = Enum.split(p1.genes, cx_point)
    {p2_head, p2_tail} = Enum.split(p2.genes, cx_point)
    {c1, c2} = {p1_head ++ p2_tail, p2_head ++ p1_tail}
    {
      %Chromosome{genes: c1, size: length(c1)},
      %Chromosome{genes: c2, size: length(c2)}
    }
  end

  def uniform(p1, p2, rate) do
    {c1, c2} =
      p1.genes
      |> Enum.zip(p2.genes)
      |> Enum.map(
        fn {x, y} ->
          if :rand.uniform() < rate do
            {x, y}
          else
            {y, x}
          end
        end)
      |> Enum.unzip()
    {
      %Chromosome{genes: c1, size: length(c1)},
      %Chromosome{genes: c2, size: length(c2)}
    }
  end

  def whole_arithmatic_crossover(p1, p2, alpha) do
    {c1, c2} =
      p1.genes
      |> Enum.zip(p2.genes)
      |> Enum.map(
        fn {x, y} ->
          {
            x * alpha +  y * ( 1 - alpha ),
            x *(1 - alpha) + y * alpha
          }
        end)
      |> Enum.unzip()
    {
      %Chromosome{genes: c1, size: length(c1)},
      %Chromosome{genes: c2, size: length(c2)}
    }
  end

  def single_point_crossover([]) do
    raise "You must have at least one parent!"
  end

  def single_point_crossover([p1 | []]), do: p1

  def single_point_crossover(parents) do
    crossover_point = :rand.uniform(hd(parents).size)
    parents
    |> Enum.chunk_every(2, 1, [hd(parents)])
    |> Enum.map( &List.to_tuple/1)
    |> Enum.reduce(
      [],
      fn {p1, p2}, chd ->
        {front, _} = Enum.split(p1.genes, crossover_point)
        {_, back} = Enum.split(p2.genes, crossover_point)
        c = %Chromosome{genes: front ++ back, size: length(p1)}
        [c | chd]
      end
    )
  end
end
