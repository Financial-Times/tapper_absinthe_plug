defmodule Tapper.Plug.AbsintheTest do
  use ExUnit.Case

  use Plug.Test

  test "creates absinthe context with tapper_id if context not present" do
    tapper_id = Tapper.Id.test_id()
    
    conn = conn("GET", "/foo")
    |> put_private(:tapper_plug, tapper_id)

    conn = Tapper.Plug.Absinthe.call(conn, [])

    assert conn.private[:absinthe]
    assert conn.private[:absinthe][:context]
    assert conn.private[:absinthe][:context][:tapper_id] == tapper_id
  end

  test "updates absinthe context with tapper_id if context present" do
    tapper_id = Tapper.Id.test_id()
    
    conn = conn("GET", "/foo")
    |> put_private(:absinthe, %{context: %{foo: :bar}})
    |> put_private(:tapper_plug, tapper_id)

    conn = Tapper.Plug.Absinthe.call(conn, [])

    assert conn.private[:absinthe]
    assert conn.private[:absinthe][:context]
    assert conn.private[:absinthe][:context][:tapper_id] == tapper_id
    assert conn.private[:absinthe][:context][:foo] == :bar
  end

  test "leaves absinthe context unchanged if tapper_id not present" do
    conn = conn("GET", "/foo")
    |> put_private(:absinthe, %{context: %{foo: :bar}})

    conn = Tapper.Plug.Absinthe.call(conn, [])

    assert conn.private[:absinthe]
    assert conn.private[:absinthe][:context]
    refute conn.private[:absinthe][:context][:tapper_id]
    assert conn.private[:absinthe][:context][:foo] == :bar
  end

end
