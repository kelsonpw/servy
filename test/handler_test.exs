defmodule HandlerTest do
  use ExUnit.Case

  import Servy.Handler, only: [handle: 1]

  test "GET /random" do
    request = """
    GET /random HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 20\r
    \r
    Bears, Lions, Tigers
    """

    assert_without_whitespace(response, expected_response)
  end

  test "GET /todos" do
    request = """
    GET /todos HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 447\r
    \r
    <h1>All The Todos!</h1>

    <ul>
      <li>Clean the kitchen - Chore</li>
      <li>Complete tickets - Work</li>
      <li>Go buy groceries - Chore</li>
      <li>Go on a camping trip - Fun</li>
      <li>Go to the movies - Fun</li>
      <li>Go to the park - Fun</li>
      <li>Learn Vue.js - Learn</li>
      <li>Pull ticket from backlog - Work</li>
      <li>Shovel the driveway - Chore</li>
      <li>Study GraphQL - Learn</li>
    </ul>
    """

    assert_without_whitespace(response, expected_response)
  end

  test "GET /bigfoot" do
    request = """
    GET /bigfoot HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 404 Not Found\r
    Content-Type: text/html\r
    Content-Length: 17\r
    \r
    No /bigfoot here!
    """

    assert_without_whitespace(response, expected_response)
  end

  test "GET /todos/1" do
    request = """
    GET /todos/1 HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 82\r
    \r
    <h1>Show Todo</h1>
    <p>
    Is Go buy groceries complete? <strong>true</strong>
    </p>
    """

    assert_without_whitespace(response, expected_response)
  end

  test "GET /stuff" do
    request = """
    GET /stuff HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 20\r
    \r
    Bears, Lions, Tigers
    """

    assert_without_whitespace(response, expected_response)
  end

  test "GET /about" do
    request = """
    GET /about HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 101\r
    \r
    <h1>Kelson's Random Refuge</h1>

    <blockquote>
    When we contemplate the whole globe...
    </blockquote>
    """

    assert_without_whitespace(response, expected_response)
  end

  test "POST /todos" do
    request = """
    POST /todos HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    Content-Type: application/x-www-form-urlencoded\r
    Content-Length: 21\r
    \r
    name=Take the dog on a walk&type=Chore
    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 201 Created\r
    Content-Type: text/html\r
    Content-Length: 50\r
    \r
    Created a Chore todo named Take the dog on a walk!
    """

    assert_without_whitespace(response, expected_response)
  end

  test "DELETE /todos/1" do
    request = """
    DELETE /todos/1 HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 403 Forbidden\r
    Content-Type: text/html\r
    Content-Length: 30\r
    \r
    Deleting todo #1 is forbidden!
    """

    assert_without_whitespace(response, expected_response)
  end

  test "GET /api/todos" do
    request = """
    GET /api/todos HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 200 OK\r
    Content-Type: application/json\r
    Content-Length: 667\r
    \r
    [{"type":"Chore","name":"Go buy groceries","id":1,"complete":true},
    {"type":"Fun","name":"Go on a camping trip","id":2,"complete":false},
    {"type":"Chore","name":"Clean the kitchen","id":3,"complete":false},
    {"type":"Fun","name":"Go to the park","id":4,"complete":true},
    {"type":"Chore","name":"Shovel the driveway","id":5,"complete":false},
    {"type":"Fun","name":"Go to the movies","id":6,"complete":false},
    {"type":"Work","name":"Pull ticket from backlog","id":7,"complete":true},
    {"type":"Learn","name":"Study GraphQL","id":8,"complete":false},
    {"type":"Work","name":"Complete tickets","id":9,"complete":true},
    {"type":"Learn","name":"Learn Vue.js","id":10,"complete":false}]
    """

    assert_without_whitespace(response, expected_response)
  end

  test "POST /api/todos" do
    request = """
    POST /api/todos HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    Content-Type: application/json\r
    Content-Length: 21\r
    \r
    {"name": "Mow the lawn", "type": "Chore"}
    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 201 Created\r
    Content-Type: text/html\r
    Content-Length: 40\r
    \r
    Created a Chore todo named Mow the lawn!
    """

    assert_without_whitespace(response, expected_response)
  end

  test "GET /pages/faq" do
    request = """
    GET /pages/faq HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 565\r
    \r
    <h1>Frequently Asked Questions</h1>
    <ul>
    <li><p><strong>Have you really seen Bigfoot?</strong></p>
    <p>Yes! In this <a href="https://www.youtube.com/watch?v=v77ijOO8oAk">totally believable video</a>!</p>
    </li>
    <li><p><strong>No, I mean seen Bigfoot <em>on the refuge</em>?</strong></p>
    <p>Oh! Not yet, but we’re still looking…</p>
    </li>
    <li><p><strong>Can you just show me some code?</strong></p>
    <p>Sure! Here’s some Elixir:</p>
    </li>
    </ul>
    <pre><code class="elixir">  [&quot;Bigfoot&quot;, &quot;Yeti&quot;, &quot;Sasquatch&quot;] |&gt; Enum.random()</code></pre>
    """

    assert_without_whitespace(response, expected_response)
  end

  defp assert_without_whitespace(a, b) do
    assert(remove_whitespace(a) == remove_whitespace(b))
  end

  defp remove_whitespace(text) do
    String.replace(text, ~r{\s}, "")
  end
end
