defmodule Genetic.Application do
  use Application

  def start(_type, _args) do
    children = [
      {Utilities.Statistics, []},
      {Utilities.Geneology, []},
    ]
    opts = [strategy: :one_for_one, name: Genetic.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
