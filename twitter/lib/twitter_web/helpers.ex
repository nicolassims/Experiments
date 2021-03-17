defmodule TwitterWeb.Helpers do

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

  def get_access_token(_conn) do
    IO.inspect("reached here")
  end
end
