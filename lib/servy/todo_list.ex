defmodule Servy.TodoList do
  alias Servy.Todo

  @data_path Path.expand("../../db", __DIR__)

  def list_todos do
    @data_path
    |> Path.join("todos.json")
    |> read_json()
    |> Poison.decode!(as: %{"todos" => [%Todo{}]})
    |> Map.get("todos")
  end

  def get_todo(id) when is_integer(id) do
    Enum.find(list_todos(), fn todo -> todo.id == id end)
  end

  def get_todo(id) when is_binary(id) do
    id
    |> String.to_integer()
    |> get_todo()
  end

  defp read_json(source) do
    case File.read(source) do
      {:ok, contents} ->
        contents

      {:error, reason} ->
        IO.inspect("Error reading #{source}: #{reason}")
        "[]"
    end
  end
end
