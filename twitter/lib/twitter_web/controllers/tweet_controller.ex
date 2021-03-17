defmodule TwitterWeb.TweetController do
  use TwitterWeb, :controller

  def index(conn, %{"access" => access}) do
    IO.inspect(access)
    render(conn, "index.html", access: access)
  end
end
