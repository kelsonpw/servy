defmodule Servy.Handler do
  alias Servy.Conv
  alias Servy.TodoController
  alias Servy.Api

  import Servy.Plugins, only: [rewrite_path: 1, log: 1, track: 1, put_content_length: 1]
  import Servy.Parser, only: [parse: 1]
  import Servy.View, only: [render_html: 2, render_markdown: 2]

  def handle(request) do
    request
    |> parse
    |> rewrite_path
    |> log
    |> route
    |> track
    |> put_content_length
    |> format_response
  end

  def route(%Conv{method: "GET", path: "/hibernate/" <> time} = conv) do
    time |> String.to_integer() |> :timer.sleep()
    %{conv | status: 200, resp_body: "Awake"}
  end

  def route(%Conv{method: "GET", path: "/random"} = conv) do
    %{conv | status: 200, resp_body: "Bears, Lions, Tigers"}
  end

  def route(%Conv{method: "GET", path: "/api/todos"} = conv) do
    Api.TodoController.index(conv)
  end

  def route(%Conv{method: "POST", path: "/api/todos"} = conv) do
    Api.TodoController.create(conv, conv.params)
  end

  def route(%Conv{method: "GET", path: "/todos"} = conv) do
    TodoController.index(conv)
  end

  def route(%Conv{method: "GET", path: "/todos/" <> id} = conv) do
    params = Map.put(conv.params, "id", id)
    TodoController.show(conv, params)
  end

  def route(%Conv{method: "POST", path: "/todos"} = conv) do
    TodoController.create(conv, conv.params)
  end

  def route(%Conv{method: "GET", path: "/about"} = conv) do
    render_html(conv, "about.html")
  end

  def route(%Conv{method: "DELETE", path: "/todos/" <> id} = conv) do
    params = Map.put(conv.params, "id", id)
    TodoController.delete(conv, params)
  end

  def route(%Conv{method: "GET", path: "/pages/" <> name} = conv) do
    render_markdown(conv, "#{name}.md")
  end

  def route(%Conv{path: path} = conv) do
    %{conv | status: 404, resp_body: "No #{path} here!"}
  end

  def format_response(%Conv{} = conv) do
    """
    HTTP/1.1 #{Conv.full_status(conv)}
    Content-Type: #{conv.resp_headers["Content-Type"]}
    Content-Length: #{conv.resp_headers["Content-Length"]}

    #{conv.resp_body}
    """
  end
end
