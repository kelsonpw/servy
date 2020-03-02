defmodule Servy.Api.TodoController do
  alias Servy.Conv

  def index(%Conv{} = conv) do
    json =
      Servy.TodoList.list_todos()
      |> Poison.encode!()

    conv = Conv.put_resp_content_type(conv, "application/json")

    %{conv | status: 200, resp_body: json}
  end

  def create(%Conv{} = conv, %{"name" => name, "type" => type}) do
    %{conv | status: 201, resp_body: "Created a #{type} todo named #{name}!"}
  end
end
