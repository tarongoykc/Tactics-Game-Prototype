class_name GameBoard
extends Node2D

const DIRECTIONS = [
	Vector2.LEFT,
	Vector2.RIGHT,
	Vector2.UP,
	Vector2.DOWN,
]

signal unit_selected(walkable_cells)

export var grid: Resource = preload("res://Grid.tres")
export var _move_dictionary: Resource = preload("res://Dictionaries/MoveDictionary.tres")
export var _unit_dictionary: Resource = preload("res://Dictionaries/UnitDictionary.tres")
export var _unit_scene = preload("res://Unit.tscn")

var _units := {}
var _active_unit: Unit
var _walkable_cells := {}

onready var _unit_overlay: UnitOverlay = $UnitOverlay
onready var _unit_path: UnitPath = $UnitPath
onready var _map: TileMap = $Map

onready var _end_turn_button: Button = $EndTurnButton
onready var _unit_info_label: RichTextLabel = $UnitInfoLabel

func _ready() -> void:
	_reinitialize()
#	_unit_overlay.draw(get_walkable_cells($Unit))
#	print(_units)

func is_occupied(cell: Vector2) -> Unit:
	return _units[cell] if _units.has(cell) else null

func _reinitialize() -> void:
	_units.clear()
	
#	var new_unit = _unit_scene.instance()
#	new_unit.position = Vector2(50, 50)
#	new_unit.set_stats("light tank")
#
#	print(add_child(new_unit))
#	print(new_unit.add_to_group("Units"))
	
	var unit_list = get_tree().get_nodes_in_group("Units")
	
	for child in unit_list:
		var unit := child as Unit
		if not unit:
			continue
#		unit.set_stats("light tank")
		_units[unit.cell] = unit

func get_walkable_cells(unit: Unit) -> Dictionary:
	return _flood_fill(unit.cell, unit.move_range, unit.move_type)

func _flood_fill(cell: Vector2, unit_move_range: int, unit_move_type: String) -> Dictionary:
#	var walkable_cells := []
	var distances := {cell : 0}
	var queue := [cell]
	
	while not queue.empty():
		var current = queue.pop_front()
		
		if not grid.is_within_bounds(current):
			continue
		if distances[current] >= unit_move_range:
			continue
		
		for direction in DIRECTIONS:
			var coordinates : Vector2 = current + direction
			var is_unit_in_cell = is_occupied(coordinates)
			var terrain_type = _map.get_cellv(coordinates)
			var move_cost: int =  _move_dictionary.get_move_cost(unit_move_type, terrain_type)
			
			if is_unit_in_cell:
				if _active_unit.faction != is_unit_in_cell.faction:
					continue
			# check if coords are in list and if 
			if distances.has(coordinates) and distances[coordinates] < distances[current] + move_cost:
				continue
			
			queue.push_back(coordinates)
			distances[coordinates] = distances[current] + move_cost
	
#	return distances.keys()
	return distances

func _select_unit(cell: Vector2) -> void:
	if not _units.has(cell):
		return
	
	_active_unit = _units[cell]
	_active_unit.is_selected = true
	
#	_walkable_cells = get_walkable_cells(_active_unit)
#	_unit_overlay.draw(_walkable_cells)
#	_unit_path.initialize(_walkable_cells)
#	emit_signal("unit_selected", _walkable_cells)
	
	if _active_unit.is_selectable and !_active_unit.is_disabled:
		_walkable_cells = get_walkable_cells(_active_unit)
		_unit_overlay.draw(_walkable_cells.keys())
		_unit_path.initialize(_walkable_cells)
		emit_signal("unit_selected", _walkable_cells)
	else:
		emit_signal("unit_selected", "inactive_unit")
	
	_unit_info_label.display_unit_info({
		"name": _active_unit.unit_name,
		"health": _active_unit.health / 100,
		"ammo": _active_unit.weapon_ammo,
		"stats": _unit_dictionary.get_unit(_active_unit.unit_name),
	})

func _deselect_active_unit() -> void:
	_active_unit.is_selected = false
	_unit_overlay.clear()
	_unit_path.stop()
	emit_signal("unit_selected", null)
	_unit_info_label.clear_unit_info()

func _clear_active_unit() -> void:
	_active_unit = null
	_walkable_cells.clear()

func move_active_unit(new_cell: Vector2) -> void:
	if is_occupied(new_cell) or not new_cell in _walkable_cells:
		return
	
	_units.erase(_active_unit.cell)
	_units[new_cell] = _active_unit
	_deselect_active_unit()
	_active_unit.walk_along(_unit_path.current_path)
	yield(_active_unit, "walk_finished")
	_clear_active_unit()

func _on_Cursor_moved(new_cell: Vector2) -> void:
	if _active_unit and _active_unit.is_selected \
			and _active_unit.is_selectable and !_active_unit.is_disabled:
		_unit_path.draw(_active_unit.cell, new_cell)
	
func _on_Cursor_accept_pressed(cell: Vector2) -> void:
	if not _active_unit:
		_select_unit(cell)
	elif !_active_unit.is_selectable or _active_unit.is_disabled:
		_deselect_active_unit()
		_clear_active_unit()
	elif _active_unit.is_selected:
		move_active_unit(cell)

func _unhandled_input(event: InputEvent) -> void:
	if _active_unit and ( \
			event.is_action_pressed("ui_cancel") or \
			(event is InputEventMouseButton and event.button_index == BUTTON_RIGHT)):
		_deselect_active_unit()
		_clear_active_unit()

func _on_Button_pressed():
	if _active_unit:
		_deselect_active_unit()
		_clear_active_unit()
	for cell in _units:
		var unit := _units[cell] as Unit
		unit.activate_unit()
