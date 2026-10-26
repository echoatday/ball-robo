extends Sprite3D

var selected_slot := 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func save_to_slot() -> void:
	var slot_file
	match(selected_slot):
		1:
			slot_file = FileAccess.open("res://saves/slot_1.json", FileAccess.WRITE)
		2: 
			slot_file = FileAccess.open("res://saves/slot_2.json", FileAccess.WRITE)
		3:
			slot_file = FileAccess.open("res://saves/slot_3.json", FileAccess.WRITE)
		4: 
			slot_file = FileAccess.open("res://saves/slot_4.json", FileAccess.WRITE)
		5:
			slot_file = FileAccess.open("res://saves/slot_5.json", FileAccess.WRITE)
		6: 
			slot_file = FileAccess.open("res://saves/slot_6.json", FileAccess.WRITE)
	
	var save_file = FileAccess.open("res://saves/savegame.json", FileAccess.READ)
	var json = JSON.new()
	var parse_result = save_file.get_as_text()
	slot_file.store_line(parse_result)

func load_from_slot() -> void:
	var slot_file
	match(selected_slot):
		1:
			slot_file = FileAccess.open("res://saves/slot_1.json", FileAccess.READ)
		2: 
			slot_file = FileAccess.open("res://saves/slot_2.json", FileAccess.READ)
		3:
			slot_file = FileAccess.open("res://saves/slot_3.json", FileAccess.READ)
		4: 
			slot_file = FileAccess.open("res://saves/slot_4.json", FileAccess.READ)
		5:
			slot_file = FileAccess.open("res://saves/slot_5.json", FileAccess.READ)
		6: 
			slot_file = FileAccess.open("res://saves/slot_6.json", FileAccess.READ)
	
	var json = JSON.new()
	var parse_result = slot_file.get_as_text()
	var save_file = FileAccess.open("res://saves/savegame.json", FileAccess.WRITE)
	save_file.store_line(parse_result)
