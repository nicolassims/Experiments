defmodule NeatthingWeb.PageController do
  use NeatthingWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
