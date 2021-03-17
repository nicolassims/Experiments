defmodule TwitterWeb.PageController do
  use TwitterWeb, :controller

  def index(conn, _params) do
    token = get_request_token()
    IO.inspect(token)
    render(conn, "index.html", request_token: token)
  end
end
