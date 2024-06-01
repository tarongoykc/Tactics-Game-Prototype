class_name MoveDictionary
extends Resource

enum TERRAIN_TYPE {
	PLAINS = 0,
	DIRT_PATH,
	ROAD,
}

func get_move_cost(move_type: String, tile_terrain_type: int) -> int:
	match move_type:
		"tracks":
			match tile_terrain_type:
				TERRAIN_TYPE.PLAINS: return 1
				TERRAIN_TYPE.DIRT_PATH: return 1
				TERRAIN_TYPE.ROAD: return 1
				_: return 1
		"wheels":
			match tile_terrain_type:
				TERRAIN_TYPE.PLAINS: return 3
				TERRAIN_TYPE.DIRT_PATH: return 2
				TERRAIN_TYPE.ROAD: return 1
				_: return 1
		"foot":
			match tile_terrain_type:
				TERRAIN_TYPE.PLAINS: return 1
				TERRAIN_TYPE.DIRT_PATH: return 1
				TERRAIN_TYPE.ROAD: return 1
				_: return 1
		_: return 1
