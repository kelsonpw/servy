defmodule Recurse do
  def triple([head | tail]) do
    [head * 3 | triple(tail)]
  end

  def triple([]), do: []

  def my_map([head | tail], func) do
    [func.(head) | my_map(tail, func)]
  end

  def my_map([], _), do: []
end

IO.inspect(Recurse.triple([1, 2, 3, 4, 5]))

nums = [1, 2, 3, 4, 5]

IO.inspect(Recurse.my_map(nums, &(&1 * 2)))

IO.inspect(Recurse.my_map(nums, &(&1 * 4)))

IO.inspect(Recurse.my_map(nums, &(&1 * 5)))
