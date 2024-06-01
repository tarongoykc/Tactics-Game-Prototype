class_name TurnQueue
extends Node2D

var active_faction
var _faction_count : int

func initialize(value: int) -> void:
	active_faction = 1
	_faction_count = value

func play_turn() -> void:
	yield(active_faction.play_turn(), "completed")
	active_faction = (active_faction + 1) % _faction_count
