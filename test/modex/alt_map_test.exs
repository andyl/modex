defmodule Modex.AltMapTest do
  use ExUnit.Case, async: true
  doctest Modex.AltMap

  import Modex.AltMap

  describe "#retake flat map" do

    @tgt %{a: 1, b: 2, c: 3}

    test "generates simple output" do
      assert retake(@tgt, [:a]) == %{a: 1}
      assert retake(@tgt, [:a, :b]) == %{a: 1, b: 2}
    end

    test "handles missing keys" do
      assert retake(@tgt, [:a, :z]) == %{a: 1}
      assert retake(@tgt, [:a, :b, :z]) == %{a: 1, b: 2}
    end

    test "handles an empty list" do
      assert retake(@tgt, []) == %{}
    end
  end

  describe "#retake flat map with sub-map" do

    @tgt %{a: 1, b: 2, c: %{x: 1, y: 2, z: 3}}

    test "handles simple and nested values" do
      assert retake(@tgt, [:a, :b]) == %{a: 1, b: 2}
      assert retake(@tgt, [:a, :c]) == %{a: 1, c: %{x: 1, y: 2, z: 3}}
    end

    test "filters the sub-map" do
      assert retake(@tgt, [:a, c: [:y]]) == %{a: 1, c: %{y: 2}}
      assert retake(@tgt, [:a, c: [:x, :y]]) == %{a: 1, c: %{x: 1, y: 2}}
    end

    test "works with missing keys" do
      assert retake(@tgt, [:a, c: [:a, :y]]) == %{a: 1, c: %{y: 2}}
      assert retake(@tgt, [:a, c: [:x, :b, :y]]) == %{a: 1, c: %{x: 1, y: 2}}
    end

    test "handles nested empty lists" do
      assert retake(@tgt, [:a, c: []]) == %{a: 1, c: %{}}
      assert retake(@tgt, [:a, z: []]) == %{a: 1}
      assert retake(@tgt, [:a, c: [:x], z: []]) == %{a: 1, c: %{x: 1}}
    end
  end

  describe "#retake two-level nested map" do

    @tgt %{a: 1, b: 2, c: %{x: %{l: 1, m: 2, n: 3}, y: 2}}

    test "handles a two-level key" do
      assert retake(@tgt, [:a, c: [x: [:m]]]) == %{a: 1, c: %{x: %{m: 2}}}
    end
  end

  describe "#retake list of maps" do

    @tgt [%{a: 1, b: 2}, %{a: 5, b: 9}]

    test "returns a list of maps" do
      assert retake(@tgt, [:a]) == [%{a: 1}, %{a: 5}]
    end
  end

  describe "#retake nested list of maps" do

    @tgt %{z: [%{a: 1, b: 2}, %{a: 5, b: 9}]}

    test "returns a deep-nested list of maps" do
      assert retake(@tgt, z: [:b]) == %{z: [%{b: 2}, %{b: 9}]}
    end
  end
end
