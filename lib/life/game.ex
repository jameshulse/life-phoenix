defmodule Life.Game do
  @type state :: :setup | :running

  @type t :: %__MODULE__{
          state: state(),
          cells: [{integer(), integer()}],
          bounds: {integer(), integer()}
        }

  defstruct(
    state: :setup,
    cells: [],
    bounds: {}
  )

  def new_game() do
    new_game({100, 100})
  end

  @spec new_game(any) :: %Life.Game{bounds: Tuple, cells: [], state: :setup}
  def new_game(bounds) do
    %__MODULE__{bounds: bounds}
  end

  def set_cells(game, cells) do
    %{game | cells: cells}
  end

  def toggle_cell(game, cell) do
    cells =
      if Enum.member?(game.cells, cell) do
        Enum.filter(game.cells, fn c -> c != cell end)
      else
        [cell | game.cells]
      end

    %{game | cells: cells}
  end

  def tick(game) do
    {x_bound, y_bound} = game.bounds

    stay_alive =
      game.cells
      |> Enum.filter(fn {x, y} -> x >= 0 && x < x_bound && y >= 0 && y < y_bound end)
      |> Enum.map(fn c -> {c, count_neighbours_at(game, c)} end)
      |> Enum.filter(fn {_c, n} -> n == 2 || n == 3 end)
      |> Enum.map(fn {c, _n} -> c end)

    come_alive =
      game.cells
      |> Enum.flat_map(&get_all_neighbours/1)
      |> Enum.filter(fn c -> !Enum.member?(game.cells, c) end)
      |> Enum.map(fn c -> {c, count_neighbours_at(game, c)} end)
      |> Enum.filter(fn {_c, n} -> n == 3 end)
      |> Enum.map(fn {c, _n} -> c end)
      |> Enum.uniq()

    %{game | cells: stay_alive ++ come_alive}
  end

  defp count_neighbours_at(game, cell) do
    get_all_neighbours(cell)
    |> Enum.map(fn n -> Enum.member?(game.cells, n) end)
    |> Enum.count(fn v -> v end)
  end

  defp get_all_neighbours({x, y}) do
    [
      {x - 1, y - 1},
      {x, y - 1},
      {x + 1, y - 1},
      {x - 1, y},
      {x + 1, y},
      {x - 1, y + 1},
      {x, y + 1},
      {x + 1, y + 1}
    ]
  end
end
