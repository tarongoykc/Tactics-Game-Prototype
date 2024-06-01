class_name WeaponDictionary
extends Resource

func get_damage_value(weapon: String, armor: String) -> int:
	match weapon:
		"rifle":
			match armor:
				"light infantry":	return 550
				"heavy infantry":	return 450
				"light vehicle":	return 250
				"heavy vehicle":	return 150
				"light tank":		return 10
				"medium tank":		return 0
				"heavy tank":		return 0
				_: return 200
		"machine gun":
			match armor:
				"light infantry":	return 850
				"heavy infantry":	return 550
				"light vehicle":	return 550
				"heavy vehicle":	return 250
				"light tank":		return 50
				"medium tank":		return 10
				"heavy tank":		return 0
				_: return 200
		"heavy machine gun":
			match armor:
				"light infantry":	return 950
				"heavy infantry":	return 850
				"light vehicle":	return 700
				"heavy vehicle":	return 600
				"light tank":		return 100
				"medium tank":		return 10
				"heavy tank":		return 0
				_: return 200
		"light tank cannon":
			match armor:
				"light infantry":	return 550
				"heavy infantry":	return 500
				"light vehicle":	return 750
				"heavy vehicle":	return 650
				"light tank":		return 550
				"medium tank":		return 250
				"heavy tank":		return 150
				_: return 200
		"medium tank cannon":
			match armor:
				"light infantry":	return 650
				"heavy infantry":	return 600
				"light vehicle":	return 950
				"heavy vehicle":	return 850
				"light tank":		return 750
				"medium tank":		return 550
				"heavy tank":		return 350
				_: return 200
		"heavy tank cannon":
			match armor:
				"light infantry":	return 850
				"heavy infantry":	return 800
				"light vehicle":	return 1150
				"heavy vehicle":	return 1050
				"light tank":		return 950
				"medium tank":		return 750
				"heavy tank":		return 550
				_: return 200
		"antitank cannon":
			match armor:
				"light infantry":	return 450
				"heavy infantry":	return 400
				"light vehicle":	return 1250
				"heavy vehicle":	return 1250
				"light tank":		return 1250
				"medium tank":		return 1050
				"heavy tank":		return 850
				_: return 200
		_: return 200
