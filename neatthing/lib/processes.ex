defmodule Processes do
  import Plug.Conn
  use GenServer

  @interval 1000

  def init(socket) do
    Process.send_after(self(), {:tick, socket}, @interval)
    {:ok, socket}
  end

  def handle_info({:tick, socket}, state) do

    randnum = Enum.random(0..100)
    IO.inspect(randnum)
    socket = assign(socket, :randnum, randnum)
    #IO.inspect(Phoenix.View.render(NeatthingWeb.PageView, "index.html", randnum: randnum))
    Process.send_after(self(), {:tick, socket}, @interval)

    {:noreply, randnum}
  end
end
