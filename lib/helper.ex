defmodule Tapper.Absinthe.Helper do
  @moduledoc """
  Support functions for using Tapper in Absinthe.
  """

  @type resolver_ret :: {:ok, any()} | {:error, any()}

  @doc """
  Wrap a resolver function call in span.

  e.g.
  ```
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
  """
  @spec in_span(info :: Absinthe.Resolution.t, fun :: (Tapper.Id.t -> resolver_ret)) :: resolver_ret
  def in_span(info = %Absinthe.Resolution{}, fun) when is_function(fun, 1) do
    tapper_id = Tapper.Plug.Absinthe.get(info)
    name = info.definition.schema_node.name
    child_id = Tapper.start_span(tapper_id, name: name)
    try do
      fun.(child_id)
    after
      Tapper.finish_span(child_id)
    end
  end

end
