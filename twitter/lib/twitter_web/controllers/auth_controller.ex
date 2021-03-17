defmodule TwitterWeb.AuthController do
  use TwitterWeb, :controller

  @spec auth(Plug.Conn.t(), any) :: Plug.Conn.t()
  def auth(conn, %{"pin" => pin, "request_token" => token}) do
    resp = ExTwitter.access_token(
      pin,
      token
    )

    resp = elem(resp, 1)
    IO.inspect(resp)
    respMap =
      %{name: resp.screen_name,
      id: resp.user_id,
      oauth_token: resp.oauth_token,
      oauth_token_secret: resp.oauth_token_secret}
    IO.inspect(resp)
    conn
    |> redirect(to: Routes.tweet_path(conn, :index, access: respMap))
  end
end
