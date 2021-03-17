defmodule TwitterWeb.TweetController do
  use TwitterWeb, :controller

  @spec index(Plug.Conn.t(), map) :: Plug.Conn.t()
  def index(conn, %{"access" => access}) do
    render(conn, "index.html", access: access)
  end

  def new(conn, %{"access" => access}) do
    render(conn, "new.html", access: access)
  end

  def create(conn, %{"access" => access, "status" => status}) do
    post_status(status)
    redirect(conn, to: Routes.tweet_path(conn, :index, access: access))
  end
end
