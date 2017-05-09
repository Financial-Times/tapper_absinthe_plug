# Tapper.Plug.Absinthe

Works in concert with [`Tapper.Plug.Trace`](https://githib.com/Finacial-Times/tapper_plug) 
to propagate the Tapper Id into the Absinthe context.

You can then access the Tapper Id via a resolver's `info` (`%Absinthe.Resolution{}`)
parameter, using `Tapper.Plug.Absinthe.get/1`.

In your router:
```elixir
plug Tapper.Plug.Trace # pick up the trace
plug Tapper.Plug.Absinthe # copy the id into the Absinthe context
```

In your resolver:
```elixir
def resolve(args, info) do
  # pick up from id info.context
  tapper_id = Tapper.Plug.Absinthe.get(info)

  tapper_id = Tapper.start_span(id, name: "my-resolver") # etc.
  ...
  Tapper.finish_span(tapper_id)
end
```

### See also

* [Absinthe Guide - Context and Authentication](http://absinthe-graphql.org/guides/context-and-authentication/)
* [`Tapper.Plug`](https://githib.com/Finacial-Times/tapper_plug)

## Installation

For the latest pre-release (and unstable) code, add github repo to your mix dependencies:

```elixir
def deps do
  [{:tapper_absinthe_plug, git: "https://github.com/Financial-Times/tapper_absinthe_plug"}]
end
```

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `tapper_plug_absinthe` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:tapper_absinthe_plug, "~> 0.1.0"}]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/tapper_plug_absinthe](https://hexdocs.pm/tapper_plug_absinthe).

