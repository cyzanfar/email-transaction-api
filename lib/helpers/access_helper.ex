defmodule Helpers.AccessHelper do
  def get_in_attempt(data, keys, default \\ []) do
    case get_in(data, keys) do
      nil -> default
      result -> result
    end
  end
end
