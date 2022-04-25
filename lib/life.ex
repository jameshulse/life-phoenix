defmodule Life do
  @moduledoc """
  Life keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  alias Life.Application

  def new_game do
    {:ok, pid} = Application.start(nil, nil)

    pid
  end

  def toggle_cell(game, cell) do
    GenServer.call(game, {:toggle_cell, cell})
  end

  def tick(game) do
    GenServer.call(game, {:tick})
  end
end
