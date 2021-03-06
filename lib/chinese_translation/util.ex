defmodule ChineseTranslation.Iterable.Macro do
  defmacro comp_fun(comp) do
    c = case comp do
      :gt   -> :>
      :gte  -> :>=
      :lt   -> :<
      :lte  -> :<=
      :eq   -> :eq
      _     -> raise @not_implemented
    end
    quote do
      fn(x, y) ->
        unquote({c, [], [{:x, [], Elixir}, {:y, [], Elixir}]})
      end
    end
  end
end

defmodule ChineseTranslation.Iterable do
  @not_implemented "not implemented"

  def filter_by(iterable, :key_len, comp, value) do
    k = key_fun(:key_len)
    c = comp_fun(comp)
    iterable
    |> Stream.filter(&(c.(k.(&1), value)))
  end

  def filter_by(iterable, :item_size, comp, value) do
    k = &(tuple_size(&1))
    c = comp_fun(comp)
    iterable
    |> Stream.filter(&(c.(k.(&1), value)))
  end

  def sort_by(iterable, key, direction) do
    k = key_fun(key)
    c = case direction do
      :desc -> :gt
      :asc  -> :lt
    end
    |> comp_fun

    iterable
    |> Enum.sort(&(c.(k.(&1), k.(&2))))
  end

  defp key_fun(:key_len), do: fn(x) -> x |> elem(0) |> String.length end
  defp key_fun(:val_len), do: fn(x) -> x |> elem(1) |> String.length end
  defp key_fun(_), do: raise @not_implemented

  defp comp_fun(comp) do
    case comp do
      :gt   -> &(&1 > &2)
      :gte  -> &(&1 >= &2)
      :lt   -> &(&1 < &2)
      :lte  -> &(&1 <= &2)
      :eq   -> &(&1 == &2)
      _     -> raise "not supported: #{comp}"
    end
  end

end
