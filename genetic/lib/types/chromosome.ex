defmodule Types.Chromosome do
  @type t::%__MODULE__{
    genes: Enum.t,
    id: binary(),
    size: integer(),
    fitness: number(),
    age: integer()
  }

  @enforce_keys :genes
  defstruct [
    :genes,
    id: Base.encode16(:crypto.strong_rand_bytes(64)),
    size: 0,
    fitness: 0,
    age: 0
  ]
end
