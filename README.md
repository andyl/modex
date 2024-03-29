# Modex

Module Extensions - extended functions for Elixir core modules.

Issues and pull requests welcome!

## Installation

The package can be installed by adding `modex` to your list of dependencies in
`mix.exs`:

```elixir
def deps do
  [
    {:modex, github: "andyl/modex"}
  ]
end
```

Documentation can be generated with [ExDoc][1].

[1]: https://github.com/elixir-lang/ex_doc

## Naming Conventions

With Modex we extend Elixir core modules including `Map`, `Enum`, and the like.
To keep extended module and function names distinct from core, we use the
following naming conventions:

1) Namespace all extended modules under `Modex`. 

2) Add an 'Alt' prefix to all extended modules.

3) Do not reuse exising function names for extended modules.

For example: `Modex.AltMap.retake` can be used as follows:

- `alias Modex.AltMap`
- `AltMap.retake(...)`
- `include AltMap`
- `retake(...)`

