defmodule LifeWeb.Life.Game do
  require Logger

  use LifeWeb, :live_view

  alias Elixir.Phoenix.LiveView.{Rendered, Socket}

  def mount(_params, _session, socket) do
    Logger.info("Game mount?")

    game = Life.new_game()

    updated_socket = assign(socket, %{game: game})

    {:ok, updated_socket}
  end

  def render(assigns) do
    # <%= live_component(Figure, tally: assigns.tally, id: 1) %>

    ~H"""
      <div class="game-holder" phx-click="toggle_cell">
        <div>cell..?</div>
      </div>
    """
  end

  def handle_event("toggle_cell", %{"cell" => cell}, socket) do
    Life.toggle_cell(socket.assigns.game, cell)
    {:noreply, nil}
  end
end
