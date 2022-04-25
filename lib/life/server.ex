defmodule Life.Server do
  use GenServer

  require Logger

  alias Life.Game

  @delay_ms 100

  def start_link(_args) do
    GenServer.start_link(__MODULE__, nil)
  end

  # Callbacks

  @impl true
  def init(nil) do
    {:ok, %{game: Game.new_game(), is_running: false}}
  end

  @impl true
  def handle_call({:toggle_cell, cell}, _from, %{game: game} = state) do
    game = Game.toggle_cell(game, cell)

    {:reply, game, %{state | game: game}}
  end

  @impl true
  def handle_call({:tick}, _from, %{game: game} = state) do
    game = Game.tick(game)

    {:reply, game, %{state | game: game}}
  end

  @impl true
  def handle_cast({:play, callback}, %{is_running: false} = state) do
    Process.send_after(self(), {:do_tick, callback}, @delay_ms)

    {:noreply, %{state | is_running: true}}
  end

  @impl true
  def handle_cast({:stop}, %{is_running: true} = state) do
    {:noreply, %{state | is_running: false}}
  end

  @impl true
  def handle_info({:do_tick, callback}, %{game: game, is_running: is_running} = state) do
    game = Game.tick(game)

    if is_running do
      Process.send_after(self(), {:do_tick, callback}, @delay_ms)
      callback.()
    end

    {:noreply, %{state | game: game, is_running: is_running}}
  end
end
