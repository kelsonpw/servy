defmodule Servy.Todo do
  defstruct id: nil, name: "", type: "", complete: false

  def is_complete(todo) do
    todo.complete == true
  end

  def order_asc_by_name(t1, t2) do
    t1.name <= t2.name
  end
end
