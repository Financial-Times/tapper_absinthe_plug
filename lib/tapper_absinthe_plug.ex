defmodule Tapper.Plug.Absinthe do
  @moduledoc """
  Works in concert with [`Tapper.Plug.Trace`](https://githib.com/Finacial-Times/tapper_plug) 
  to propagate the Tapper Id into the Absinthe context.
  
  You can then access the Tapper id via a resolver's `info` (`%Absinthe.Resolution{}`)
  parameter, using this modules' `get/1` function.

  In your router:
  ```
  plug Tapper.Plug.Trace # pick up the trace
  plug Tapper.Plug.Absinthe # copy the id into the Absinthe context
  ```

  In your resolver:
  ```
  def resolve(args, info) do
    # pick up from id info.context
    tapper_id = Tapper.Plug.Absinthe.get(info)

    tapper_id = Tapper.start_span(id, name: "my-resolver") # etc.
    ...
    Tapper.finish_span(tapper_id)
  end
  ```
  """

  @doc "Get the tapper id from the Absinthe Resolution info if present, or return `:ignore`."
  @spec get(resolution :: %Absinthe.Resolution{} | map()) :: Tapper.Id.t
  def get(info)

  def get(%{context: %{tapper_id: id}}), do: id
  def get(_), do: :ignore

  @behaviour Plug

  import Plug.Conn

  def init(opts), do: opts

  def call(conn = %Plug.Conn{private: %{tapper_plug: tapper_id}}, _) do
    absinthe = conn.private[:absinthe] || %{context: %{}}

    absinthe = put_in(absinthe[:context][:tapper_id], tapper_id)

    put_private(conn, :absinthe, absinthe)
  end

  def call(conn = %Plug.Conn{}, _), do: conn

end
