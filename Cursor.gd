tool
class_name Cursor
extends Node2D

signal accept_pressed(cell)
signal moved(new_cell)

export var grid: Resource = preload("res://Grid.tres")
export var ui_cooldown_slow := 0.1
export var ui_cooldown_fast := 0.02
export var ui_cooldown_count := 3

var cell := Vector2.ZERO setget set_cell
var _walkable_cells: Array = []
var _unit_can_move: bool = true

onready var _timer: Timer = $Timer

func _ready() -> void:
	_timer.wait_time = ui_cooldown_fast
	position = grid.calc_map_pos(cell)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mouse_cell = grid.calc_grid_coords(event.position)
		self.cell = mouse_cell if _check_valid_cell(mouse_cell) else _find_closest_cell(mouse_cell)
	elif event.is_action_pressed("click") or event.is_action_pressed("ui_accept"):
		emit_signal("accept_pressed", cell)
		get_tree().set_input_as_handled()
	
	var should_move := event.is_pressed()
	if event.is_echo():
		should_move = should_move and _timer.is_stopped()
	
	if not should_move:
		return
	
	if event.is_echo():
		if ui_cooldown_count > 0:
			ui_cooldown_count -= 1
		else:
			 _timer.wait_time = ui_cooldown_fast
	else:
		ui_cooldown_count = 3
		_timer.wait_time = ui_cooldown_slow
	
	if event.is_action("ui_right") and _check_valid_cell(self.cell + Vector2.RIGHT):
		self.cell += Vector2.RIGHT
	elif event.is_action("ui_left") and _check_valid_cell(self.cell + Vector2.LEFT):
		self.cell += Vector2.LEFT
	elif event.is_action("ui_up") and _check_valid_cell(self.cell + Vector2.UP):
		self.cell += Vector2.UP
	elif event.is_action("ui_down") and _check_valid_cell(self.cell + Vector2.DOWN):
		self.cell += Vector2.DOWN

func _check_valid_cell(cell: Vector2) -> bool:
	if _walkable_cells.empty() or cell in _walkable_cells:
		return true
	else:
		return false

func _draw() -> void:
	draw_rect(Rect2(-grid.cell_size / 2, grid.cell_size), Color.aliceblue, false, 2.0)

func set_cell(value: Vector2) -> void:
	var new_cell: Vector2 = grid.clamp(value)
	if new_cell.is_equal_approx(cell):
		return
	
	cell = new_cell
	position = grid.calc_map_pos(cell)
	emit_signal("moved", cell)
	_timer.start()

func _find_closest_cell(cell: Vector2) -> Vector2:
	if _walkable_cells.empty():
		return cell
	else:
		var nearest_cell: Vector2 = _walkable_cells[0]
		for w_cell in _walkable_cells:
			if cell.distance_to(w_cell) <= cell.distance_to(nearest_cell):
				nearest_cell = w_cell
		return nearest_cell

func _on_GameBoard_unit_selected(walkable_cells):
	if walkable_cells == null:
		_walkable_cells = []
		_unit_can_move = false
	elif walkable_cells is String:
		_walkable_cells = []
		_unit_can_move = false
	else:
		_walkable_cells = walkable_cells.keys()
		_unit_can_move = true
