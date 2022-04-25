defmodule Life.Server do
  use GenServer

  alias Life.Game

  def start_link(_args) do
    GenServer.start_link(__MODULE__, nil)
  end

  # Callbacks

  @impl true
  def init(nil) do
    {:ok, Game.new_game()}
  end

  @impl true
  def handle_call({:toggle_cell, cell}, _from, game) do
    game = Game.toggle_cell(game, cell)

    {:reply, game, game}
  end

  @impl true
  def handle_call({:tick}, _from, game) do
    game = Game.tick(game)

    {:reply, game, game}
  end
end
