defmodule SkynetWeb.TerminatorLiveView do
  use Phoenix.LiveView

  @topic "terminators"

  def render(assigns) do
    SkynetWeb.PageView.render("terminators.html", assigns)
  end

  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(Skynet.PubSub, @topic)

    {:ok, fetch(socket)}
  end

  def handle_event("terminate", %{"unit" => unit}, socket) do
    unit
    |> String.to_integer()
    |> Skynet.Server.terminate()

    {:noreply, fetch(socket)}
  end

  def handle_event("spawn", _, socket) do
    Skynet.Server.spawn()

    {:noreply, fetch(socket)}
  end

  def handle_info(:inventory_changed, socket) do
    {:noreply, fetch(socket)}
  end

  defp fetch(socket) do
    assign(socket, live_units: Skynet.Server.inventory())
  end
end
