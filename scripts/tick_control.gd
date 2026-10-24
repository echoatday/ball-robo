extends Sprite3D

@export var box_texture: Array[Texture]
var item_status := false
var current_index := 0
var current_item

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_index = int(self.name.remove_chars("tick_"))
	var current_room = StationMap.rooms[current_index].instantiate()
	current_item = current_room.get_node("Pickup").target_item
	
	var display_text = ""
	match(current_index):
		24:
			display_text = "MC"
		25:
			display_text = "PS"
		26:
			display_text = "PN"
		34:
			display_text = "OH"
		35:
			display_text = "RM"
		36:
			display_text = "WD"
		44:
			display_text = "H"
		45:
			display_text = "BF"
		46:
			display_text = "CS"
		54:
			display_text = "CD"
		55:
			display_text = "FW"
		56:
			display_text = "EB"
	$map_initials.text = display_text


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if owner.current_level != current_index:
		$selection.visible = false
	else:
		$selection.visible = true
	
	match(current_item):
		0:
			item_status = Globals.unlock_door
		1:
			item_status = Globals.unlock_hatch
		2:
			item_status = Globals.unlock_sheet
		3:
			item_status = Globals.unlock_iris
		4:
			item_status = Globals.unlock_vault
		5:
			item_status = Globals.unlock_roll
		6:
			item_status = Globals.unlock_jump
		7:
			item_status = Globals.unlock_walljump
		8:
			item_status = Globals.unlock_lateralboost
		9:
			item_status = Globals.unlock_downboost
		10:
			item_status = Globals.unlock_bounce
		11:
			item_status = Globals.unlock_grapple
		12:
			item_status = Globals.unlock_spin
		13:
			item_status = Globals.unlock_waterproofing
		14:
			item_status = Globals.unlock_energy_1
		15:
			item_status = Globals.unlock_energy_2
		16:
			item_status = Globals.unlock_heat
	
	if not item_status:
		texture = box_texture[0]
	else:
		texture = box_texture[1]
