defmodule TwitterWeb.Helpers do

  def get_user_name(access) do
    Map.get(access, "name")
  end

  def get_limit_search() do
    limit = ExTwitter.rate_limit_status()
    searchLimits = limit.resources.search
    _searchData = Map.get(searchLimits, :"/search/tweets")
    #"Remaining: #{inspect searchData.remaining} Limit: #{inspect searchData.limit}"

    appLimits = limit.resources.application
    appData = Map.get(appLimits, :"/application/rate_limit_status")
    "Remaining: #{inspect appData.remaining} Limit: #{inspect appData.limit}"
  end

  def get_request_token(url \\ nil)  do
    resp = ExTwitter.request_token(url)
    IO.inspect(resp)
    resp.oauth_token
  end

  def get_authorize_url(conn, token) do
    #token = conn.assigns[:request_token]
    resp = ExTwitter.authorize_url(token)
    IO.inspect(resp)
    elem(resp, 1)
  end

  def set_access(access) do
    IO.inspect(access)
    config = ExTwitter.Config.get()
    %{"oauth_token" => oauth_token,
      "oauth_token_secret" => oauth_token_secret } = access

    config = config
    |> Keyword.put(:access_token, oauth_token)
    |> Keyword.put(:access_token_secret, oauth_token_secret)

    IO.inspect(config)
    ExTwitter.Config.set(:process, config)
  end

  def get_status(access) do
    set_access(access)
    tl = ExTwitter.API.Timelines.user_timeline()
    IO.inspect(tl)
    tweet = Enum.fetch!(tl, 0)
    IO.inspect(tweet)
    tweet.text
  end

  def post_status(access, status) do
    set_access(access)
    resp = ExTwitter.API.Tweets.update(status)
    IO.inspect(resp)
    resp
  end
end
