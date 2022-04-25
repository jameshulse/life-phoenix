defmodule LifeWeb.Life.Game do
  require Logger

  use LifeWeb, :live_view

  alias Elixir.Phoenix.LiveView.{Rendered, Socket}
  alias Phoenix.PubSub

  def mount(_params, _session, socket) do
    game = Life.new_game()

    updated_socket = assign(socket, %{game: game, cells: [], state: :paused})

    PubSub.subscribe(Life.PubSub, "on_tick", link: true)

    {:ok, updated_socket}
  end

  def render(assigns) do
    ~H"""
      <div class="game-holder">
        <%= for y <- 1..50 do %>
          <div class="row">
            <%= for x <- 1..50 do %>
              <div
                class={"cell #{if(cell_selected?(assigns.cells, {x, y}), do: "cell--alive") }"}
                phx-click="toggle_cell"
                phx-value-x={x}
                phx-value-y={y}
              ></div>
            <% end %>
          </div>
        <% end %>
      </div>

      <div class="controls">
        <button disabled={assigns.state == :running} phx-click="tick">Tick ⏭</button>
        <%= if assigns.state == :paused do %>
          <button phx-click="play">Play ►</button>
        <% else %>
          <button phx-click="pause">Pause ⏸</button>
        <% end %>
      </div>
    """
  end

  defp cell_selected?(cells, cell) do
    Enum.member?(cells, cell)
  end

  def handle_event("toggle_cell", %{"x" => x, "y" => y}, socket) do
    {x, _} = Integer.parse(x)
    {y, _} = Integer.parse(y)

    %{cells: cells} = Life.toggle_cell(socket.assigns.game, {x, y})

    socket = assign(socket, :cells, cells)

    {:noreply, socket}
  end

  def handle_event("tick", _params, socket) do
    %{cells: cells} = Life.tick(socket.assigns.game)

    socket = assign(socket, :cells, cells)

    {:noreply, socket}
  end

  def handle_event("play", _params, socket) do
    Life.play(socket.assigns.game, fn ->
      PubSub.broadcast!(Life.PubSub, "on_tick", nil)
    end)

    socket = assign(socket, :state, :running)

    {:noreply, socket}
  end

  def handle_event("pause", _params, socket) do
    Life.stop(socket.assigns.game)

    socket = assign(socket, :state, :paused)

    {:noreply, socket}
  end

  # TODO: This should be a callback from the pubsub callback..
  def handle_info(_params, socket) do
    %{cells: cells} = Life.tick(socket.assigns.game)

    socket = assign(socket, :cells, cells)

    {:noreply, socket}
  end
end
