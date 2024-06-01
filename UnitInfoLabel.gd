class_name UnitInfoLabel
extends RichTextLabel

func display_unit_info(unit_info: Dictionary) -> void:
	var ammo_count = str(unit_info["ammo"],  "\\", unit_info["stats"]["max ammo"]) \
			if unit_info["stats"]["max ammo"] > 0 else "--"
	var secondary = unit_info["stats"]["secondary"] \
			if unit_info["stats"]["secondary"] is String else "--"
	
	var label = str(
		unit_info["name"], "\n",
		"HP: ", unit_info["health"], "\n",
		"Primary: ", unit_info["stats"]["primary"], "\n",
		"Ammo: ", ammo_count, "\n",
		"Secondary: ", secondary,
		"Move Type: ", unit_info["stats"]["move type"], "\n",
		"Move Range: ", unit_info["stats"]["move range"]
	)
	
	text = label

func clear_unit_info() -> void:
	text = ""
