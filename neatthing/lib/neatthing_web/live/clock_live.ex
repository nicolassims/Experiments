defmodule NeatthingWeb.ClockLive do
  use NeatthingWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    if (connected?(socket)) do
      :timer.send_interval(1000, self(), :tick)
    end

    socket = assign_current_time(socket)

    {:ok, socket}
  end

  @impl true
  def handle_event("suggest", %{"q" => query}, socket) do
    {:noreply, assign(socket, results: search(query), query: query)}
  end

  @impl true
  def handle_event("search", %{"q" => query}, socket) do
    case search(query) do
      %{^query => vsn} ->
        {:noreply, redirect(socket, external: "https://hexdocs.pm/#{query}/#{vsn}")}

      _ ->
        {:noreply,
         socket
         |> put_flash(:error, "No dependencies found matching \"#{query}\"")
         |> assign(results: %{}, query: query)}
    end
  end

  @impl true
  def render(assigns) do
    ~L"""
    <h1><%= @now %></h1>
    """
  end

  @impl true
  def handle_info(:tick, socket) do
    socket = assign_current_time(socket)

    {:noreply, socket}
  end

  defp assign_current_time(socket) do
    now = Time.utc_now()
    |> Time.to_string()
    |> String.split(".")
    |> hd

    assign(socket, now: now)
  end

  defp search(query) do
    if not NeatthingWeb.Endpoint.config(:code_reloader) do
      raise "action disabled when not in development"
    end

    for {app, desc, vsn} <- Application.started_applications(),
        app = to_string(app),
        String.starts_with?(app, query) and not List.starts_with?(desc, ~c"ERTS"),
        into: %{},
        do: {app, vsn}
  end
end
