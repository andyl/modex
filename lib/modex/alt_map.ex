defmodule Modex.AltMap do

  @moduledoc """
  Extended functions for Elixir's `Map` module.
  """

  @doc """
  Like `Map.take`, but recursively filters nested data structures.

  ('retake' == 'recursive take')

  Use this function to extract sub-elements from a hierarchical data structure.

  For example, when you do an Ecto query using a schema and preloaded
  associations, you can use this function to select sub-elements from the
  parent element and it's children.

  Examples:

  # simple case works just like Map.take 
  iex> retake(%{a: 1, b: 2}, [:a])
  %{a: 1}
  
  # with nested sub-maps
  iex> retake(%{a: 1, b: 2, c: %{x: 1, y: 2}}, [:a, c: [:x]])
  %{a: 1, c: %{x: 1}}
  
  # with lists of maps
  iex> retake([%{a: 1, b: 2}, %{a: 4, b: 5}], [:a])
  [%{a: 1}, %{a: 4}]
  
  # with sub-lists of maps
  iex> retake(%{x: [%{a: 1, b: 2}, %{a: 4, b: 5}]}, [x: [:a]])
  %{x: [%{a: 1}, %{a: 4}]}
  """
  def retake(input, keys) when is_list(input) and is_list(keys) do
    Enum.map(input, fn(map) -> retake(map, keys) end)
  end
  
  def retake(input, keys) when is_map(input) and is_list(keys) do 
    atoms = Enum.filter(keys, &(is_atom(&1)))
    lists = Enum.filter(keys, &(is_tuple(&1)))
    retake(input, atoms, lists)
  end

  def retake(_, _) do
    %{}
  end

  defp retake(input, keys, subkeys) when is_map(input) and is_list(keys) and is_list(subkeys) do
    base = Map.take(input, keys)
    Enum.reduce(subkeys, base, fn(tuple, acc) -> 
      {key, val} = tuple
      subtree = Map.get(input, key)
      if subtree do
        submap = retake(subtree, val)
        Map.merge(acc, %{key => submap})
      else
        acc
      end
    end)
  end

  @doc """
  Merges lists of maps.

  Examples:

  # simple case with one list of maps 
  iex> merge_list([%{a: 1}, %{b: 2}])
  %{a: 1, b: 2}

  """
  def merge_list(list) when is_list(list) do
    [h | t] = list
    merge_list(h, t)
  end

  def merge_list(map) when is_map(map) do
    map
  end

  @doc """
  Merges two lists of maps.

  Examples:

  # merge two lists
  iex> merge_list([%{a: 1}], [%{b: 2}])
  %{a: 1, b: 2}

  # merge a map and a list
  iex> merge_list(%{a: 1}, [%{b: 2}])
  %{a: 1, b: 2}

  # merge a list and a map
  iex> merge_list([%{a: 1}], %{b: 2})
  %{a: 1, b: 2}

  """
  def merge_list(map1, map2) when is_map(map1) and is_map(map2) do
    Map.merge(map1, map2)
  end

  def merge_list([], []) do
    %{}
  end

  def merge_list(map, []) when is_map(map) do
    map
  end

  def merge_list([], map) when is_map(map) do
    map
  end

  def merge_list(map, list) when is_map(map) and is_list(list) do
    [h | t] = list
    Map.merge(map, h)
    |> merge_list(t)
  end

  def merge_list(list1, list2) when is_list(list1) and is_list(list2) do
    Enum.concat(list1, list2)
    |> merge_list()
  end

  def merge_list(list, map) when is_list(list) and is_map(map) do
    Enum.concat(list, [map])
    |> merge_list()
  end
end
