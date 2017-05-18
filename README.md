# Tapper Absinthe Integration

Works in concert with [`Tapper.Plug.Trace`](https://github.com/Financial-Times/tapper_plug)
to propagate the Tapper Id into the Absinthe context.

[![Hex pm](http://img.shields.io/hexpm/v/tapper_absinthe_plug.svg?style=flat)](https://hex.pm/packages/tapper_absinthe_plug) [![Inline docs](http://inch-ci.org/github/Financial-Times/tapper_absinthe_plug.svg)](http://inch-ci.org/github/Financial-Times/tapper_absinthe_plug) [![Build Status](https://travis-ci.org/Financial-Times/tapper_absinthe_plug.svg?branch=master)](https://travis-ci.org/Financial-Times/tapper_absinthe_plug)


## Synopsis

Using this plug, you can access the Tapper Id via a resolver's `info` (`%Absinthe.Resolution{}`)
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
* [`Tapper.Plug`](https://github.com/Financial-Times/tapper_plug)

The API documentation can be found at [https://hexdocs.pm/tapper_absinthe_plug](https://hexdocs.pm/tapper_absinthe_plug).

## Helpers

Since you'll probably want to wrap a span around every resolver call, we provide `Tapper.Absinthe.Helper.in_span/2`,
which wraps a new child span around a function call.

Using this in your Absinthe schema or type definition looks something like:

```elixir
import Tapper.Absinthe.Helper, only: [in_span: 2]


query do

  @desc "Get a Thing by UUID"
  field :thing, type: :thing do
    @desc "A Thing UUID"
    arg :id, non_null(:id)
    resolve fn(%{id: thing_id}, info) ->

      in_span(info, fn(tapper_id) ->
        # call real resolver function, passing %Tapper.Id{} etc.
        MyApp.ThingResolver.thing(thing_id, tapper_id)
      end)
      
    end
  end

end
```

When the resolver is called, `in_span/2` will start a child span,
using the `Tapper.Id` from the Absinthe context, and apply the function, passing the child span id, so you can add annotations and pass to other functions, and returning the result. It will take care of finishing the child span, even in exception situations.

The name of the child span will be the schema node name, in this case `thing`.

## Installation

For the latest pre-release (and unstable) code, add github repo to your mix dependencies:

```elixir
def deps do
  [{:tapper_absinthe_plug, git: "https://github.com/Financial-Times/tapper_absinthe_plug"}]
end
```

For release versions, the package can be installed by adding `tapper_absinthe_plug` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:tapper_absinthe_plug, "~> 0.1.0"}]
end
```

Ensure that the `:tapper` application is present in your mix project's applications:

```elixir
  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {MyApp, []},
      applications: [:tapper]
    ]
  end
```
