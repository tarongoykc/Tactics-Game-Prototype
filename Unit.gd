tool
class_name Unit
extends Path2D

signal walk_finished

export var grid: Resource = preload("res://Grid.tres")
export var unit_dictionary: Resource = preload("res://Dictionaries/UnitDictionary.tres")
export var skin: Texture setget set_skin
export var skin_offset := Vector2.ZERO setget set_skin_offset
export var move_speed := 600.0

export var unit_name: String = "light tank" setget set_unit_name
export var move_type: String = "tracks" setget set_move_type
export var move_range := 6 setget set_move_range
export var faction := 1 setget set_faction
export var health := 1000 setget set_health
export var fuel := 100 setget set_fuel
export var armor_type: String = "light vehicle" setget set_armor_type
export var weapon_range: int = 2 setget set_weapon_range
export var weapon_primary: String = "light tank cannon" setget set_primary
export var weapon_ammo: int = 5 setget set_primary_ammo
export var weapon_ammo_max: int = 5 setget set_primary_ammo_max
export var weapon_secondary: String = "machine gun" setget set_secondary

var cell := Vector2.ZERO setget set_cell
var is_selected := false setget set_is_selected
export var is_selectable := false setget _set_selectable
export var is_disabled := false setget _set_disabled

var _is_walking := false setget _set_is_walking

onready var _sprite: Sprite = $PathFollow2D/Sprite
onready var _anim_player: AnimationPlayer = $AnimationPlayer
onready var _path_follow: PathFollow2D = $PathFollow2D


func _ready() -> void:
	self.cell = grid.calc_grid_coords(position)
	position = grid.calc_map_pos(cell)
	
	print(cell)
	print(position)
	
	if not Engine.editor_hint:
		curve = Curve2D.new()
	
	_anim_player.play("idle")

func set_stats(unit_type: String) -> void:
	var stats = unit_dictionary.get_unit(unit_type)
	
	skin = load(stats["sprite"])
	move_type = stats["move type"]
	move_range = stats["move range"]
	armor_type = stats["armor type"]
	weapon_range = stats["range"]
	weapon_primary = stats["primary"]
	weapon_ammo_max = stats["max ammo"]
	weapon_ammo = stats["max ammo"]
	weapon_secondary = stats["secondary"]

func _process(delta: float) -> void:
	if _path_follow:
		_path_follow.offset += move_speed * delta
		
		if _path_follow.unit_offset >= 1.0:
			self._is_walking = false
			_path_follow.offset = 0.0
			position = grid.calc_map_pos(cell)
			curve.clear_points()
			emit_signal("walk_finished")
			
			is_disabled = true
			_anim_player.play("disabled")

func walk_along(path: PoolVector2Array) -> void:
	if path.empty():
		return
	
	curve.add_point(Vector2.ZERO)
	for point in path:
		curve.add_point(grid.calc_map_pos(point) - position)
	cell = path[-1]
	self._is_walking = true

func set_cell(value: Vector2) -> void:
	cell = grid.clamp(value)

func set_is_selected(value: bool) -> void:
	is_selected = value
	if is_selected:
		_anim_player.play("selected")
	elif is_disabled:
		_anim_player.play("disabled")
	else:
		_anim_player.play("idle")

func _set_selectable(value: bool) -> void:
	is_selectable = value
	
func _set_disabled(value: bool) -> void:
	is_disabled = value

func set_skin(value: Texture) -> void:
	skin = value
	if not _sprite:
		yield(self, "ready")
	_sprite.texture = value

func set_skin_offset(value: Vector2) -> void:
	skin_offset = value
	if not _sprite:
		yield(self, "ready")
	_sprite.position = value

func set_unit_name(value: String) -> void:
	unit_name = value

func set_move_range(value: int) -> void:
	move_range = value

func _set_is_walking(value: bool) -> void:
	_is_walking = value
	set_process(_is_walking)

func set_move_type(value: String) -> void:
	move_type = value

func set_health(value: int) -> void:
	health = value

func set_fuel(value: int) -> void:
	fuel = value

func set_faction(value: int) -> void:
	faction = value

func set_armor_type(value: String) -> void:
	armor_type = value

func set_weapon_range(value: int) -> void:
	weapon_range = value

func set_weapons(weapons: Array, ammo: int) -> void:
	weapon_primary = weapons[0]
	weapon_secondary = weapons[1]
	weapon_ammo = ammo
	weapon_ammo_max = ammo

func set_primary(value: String) -> void:
	weapon_primary = value
	
func set_secondary(value: String) -> void:
	weapon_secondary = value

func set_primary_ammo(value: int) -> void:
	weapon_ammo = value

func set_primary_ammo_max(value: int) -> void:
	weapon_ammo_max = value

func activate_unit() -> void:
	_set_selectable(true)
	_set_disabled(false)
	_anim_player.play("idle")
