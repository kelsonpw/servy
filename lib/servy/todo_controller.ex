defmodule Servy.TodoController do
  alias Servy.TodoList
  alias Servy.Todo

  import Servy.View, only: [render: 3]

  def index(conv) do
    todos =
      TodoList.list_todos()
      |> Enum.sort(&Todo.order_asc_by_name/2)

    render(conv, "index.eex", todos: todos)
  end

  def show(conv, %{"id" => id}) do
    todo = TodoList.get_todo(id)

    render(conv, "show.eex", todo: todo)
  end

  def create(conv, %{"name" => name, "type" => type}) do
    %{conv | status: 201, resp_body: "Created a #{type} todo named #{name}!"}
  end

  def delete(conv, %{"id" => id}) do
    %{conv | status: 403, resp_body: "Deleting todo ##{id} is forbidden!"}
  end
end
