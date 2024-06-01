class_name Grid
extends Resource

const GRID_WIDTH := 32
const GRID_HEIGHT := 18

export var size := Vector2(GRID_WIDTH, GRID_HEIGHT)
export var cell_size := Vector2(20, 20)

var _half_cell_size := cell_size / 2

func calc_map_pos(grid_pos: Vector2) -> Vector2:
	return grid_pos * cell_size + _half_cell_size

func calc_grid_coords(map_pos: Vector2) -> Vector2:
	return (map_pos / cell_size).floor()

func is_within_bounds(cell_coords: Vector2) -> bool:
	var x_out := cell_coords.x >= 0 and cell_coords.x < size.x
	var y_out := cell_coords.y >= 0 and cell_coords.y < size.y
	return x_out and y_out

func clamp(grid_pos: Vector2) -> Vector2:
	var out := grid_pos
	out.x = clamp(out.x, 0, size.x - 1.0)
	out.y = clamp(out.y, 0, size.y - 1.0)
	return out

func as_index(cell: Vector2) -> int:
	return int(cell.x + size.x * cell.y)
