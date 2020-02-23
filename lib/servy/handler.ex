defmodule Servy.Handler do
  def handle(request) do
    request
    |> parse
    |> rewrite_path
    |> log
    |> route
    |> track
    |> format_response
  end

  def parse(request) do
    [method, path, _] =
      request
      |> String.split("\n")
      |> List.first()
      |> String.split(" ")

    %{
      method: method,
      path: path,
      resp_body: "",
      status: nil
    }
  end

  def track(%{status: 404, path: path} = conv) do
    IO.puts("Warning #{path} is on the loose!")
    conv
  end

  def track(conv), do: conv

  def rewrite_path(%{path: "/wildthings"} = conv) do
    %{conv | path: "/animals"}
  end

  def rewrite_path(conv), do: conv

  def log(conv), do: IO.inspect(conv)

  def route(conv), do: route(conv, conv.method, conv.path)

  def route(conv, "GET", "/animals") do
    %{conv | status: 200, resp_body: "Cats, Dogs, and Mice"}
  end

  def route(conv, "GET", "/food") do
    %{conv | status: 200, resp_body: "Pizza, Salad, and Cheese"}
  end

  def route(conv, "GET", "/food/" <> id) do
    %{conv | status: 200, resp_body: "Food #{id}"}
  end

  def route(conv, _method, path) do
    %{conv | status: 404, resp_body: "#{path} not found!"}
  end

  def format_response(%{resp_body: resp_body, status: status}) do
    """
    HTTP/1.1 #{status} #{status_reason(status)}
    Content-Type: text/html
    Content-Length: #{String.length(resp_body)}

    #{resp_body}
    """
  end

  defp status_reason(code) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Internal Server Error"
    }[code]
  end
end

request = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts(response)

request = """
GET /animals HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts(response)

request = """
GET /food HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts(response)

request = """
GET /food/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts(response)

request = """
GET /fooder HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts(response)
