defmodule NeatthingWeb.PageLive do
  use NeatthingWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket = socket
    |> assign(:light_bulb_status, "off")
    |> assign(:on_button_status, "")
    |> assign(:off_button_status, "disabled")

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
    <h1>The light is <%= @light_bulb_status %>.</h1>
    <button phx-click="on" <%= @on_button_status %>>On</button>
    <button phx-click="off" <%= @off_button_status %>>Off</button>
    """
  end

  @impl true
  def handle_event("on", _value, socket) do
    socket = socket
    |> assign(:light_bulb_status, "on")
    |> assign(:on_button_status, "disabled")
    |> assign(:off_button_status, "")

    {:noreply, socket}
  end

  @impl true
  def handle_event("off", _value, socket) do
    socket = socket
    |> assign(:light_bulb_status, "off")
    |> assign(:on_button_status, "")
    |> assign(:off_button_status, "disabled")

    {:noreply, socket}
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
