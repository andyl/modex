defmodule Modex.AltMap do

  @moduledoc """
  Utility functions for Map data structures.
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
  iex> import Modex.AltMap
  iex> retake(%{a: 1, b: 2}, [:a])
  %{a: 1}
  
  # with nested sub-maps
  iex> import Modex.AltMap
  iex> retake(%{a: 1, b: 2, c: %{x: 1, y: 2}}, [:a, c: [:x]])
  %{a: 1, c: %{x: 1}}
  
  # with lists of maps
  iex> import Modex.AltMap
  iex> retake([%{a: 1, b: 2}, %{a: 4, b: 5}], [:a])
  [%{a: 1}, %{a: 4}]
  
  # with sub-lists of maps
  iex> import Modex.AltMap
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
end
