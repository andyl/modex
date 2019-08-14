defmodule ModexTest do
  use ExUnit.Case
  doctest Modex

  test "greets the world" do
    assert Modex.hello() == :world
  end
end
