class_name UnitDictionary
extends Resource

func get_unit(name: String) -> Dictionary:
	
	name =  name.to_lower()
	
	match name:
		"rifles":
			return {
				"sprite": "res://Units/unit_rifles.png",
				"move type": "foot",
				"move range": 3,
				"armor type": "light infantry",
				"range": 2,
				"primary": "rifle",
				"max ammo": -1,
				"secondary": -1,
			}
		"recon":
			return {
				"sprite": "res://Units/unit_recon.png",
				"move type": "wheels",
				"move range": 8,
				"armor type": "light vehicle",
				"range": 2,
				"primary": "machine gun",
				"max ammo": 5,
				"secondary": -1,
			}
		"armored car":
			return {
				"sprite": "res://Units/unit_armored_car.png",
				"move type": "wheels",
				"move range": 7,
				"armor type": "light vehicle",
				"range": 2,
				"primary": "light tank cannon",
				"max ammo": 4,
				"secondary": -1,
			}
		"light tank":
			return {
				"sprite": "res://Units/unit_tank.png",
				"move type": "tracks",
				"move range": 5,
				"armor type": "light tank",
				"range": 2,
				"primary": "light tank cannon",
				"max ammo": 5,
				"secondary": "machine gun",
			}
		_: return {}
