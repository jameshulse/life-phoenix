defmodule Life.GameTest do
  use ExUnit.Case

  alias Life.Game

  test "game created is in setup state" do
    game = Game.new_game()

    assert game.state == :setup
  end

  test "can set cells" do
    game =
      Game.new_game()
      |> Game.set_cells([{0, 0}, {0, 1}])

    assert game.cells == [{0, 0}, {0, 1}]
  end

  test "can toggle dead cell on" do
    game =
      Game.new_game()
      |> Game.toggle_cell({1, 1})

    assert Enum.member?(game.cells, {1, 1})
  end

  test "can toggle living cell off" do
    game =
      Game.new_game()
      |> Game.set_cells([{1, 1}])
      |> Game.toggle_cell({1, 1})

    assert !Enum.member?(game.cells, {1, 1})
  end

  test "cell with two neighbours survives" do
    game =
      Game.new_game()
      |> Game.set_cells([{1, 1}, {1, 0}, {2, 2}])
      |> Game.tick()

    assert Enum.member?(game.cells, {1, 1})
  end

  test "cell with three neighbours survives" do
    game =
      Game.new_game()
      |> Game.set_cells([{1, 1}, {1, 0}, {2, 2}, {0, 2}])
      |> Game.tick()

    assert Enum.member?(game.cells, {1, 1})
  end

  test "cell dies with no neighbours" do
    game =
      Game.new_game()
      |> Game.set_cells([{1, 1}])
      |> Game.tick()

    assert !Enum.member?(game.cells, {1, 1})
  end

  test "cell with 1 neighbour dies" do
    game =
      Game.new_game()
      |> Game.set_cells([{1, 0}, {1, 1}])
      |> Game.tick()

    assert !Enum.member?(game.cells, {1, 1})
  end

  test "cell with 4 neighbours dies" do
    game =
      Game.new_game()
      |> Game.set_cells([{1, 0}, {0, 1}, {1, 1}, {2, 1}, {1, 2}])
      |> Game.tick()

    assert !Enum.member?(game.cells, {1, 1})
  end

  test "cell with 3 living neighbours comes to life" do
    game =
      Game.new_game()
      |> Game.set_cells([{1, 0}, {0, 1}, {2, 1}])
      |> Game.tick()

    assert Enum.member?(game.cells, {1, 1})
  end
end
