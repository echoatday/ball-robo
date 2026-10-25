extends Sprite3D

@export var box_texture: Array[Texture]
var item_status := false
var button_status := false
var map_status := false
var current_index := 0
var current_item
var current_button
var current_map

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_index = int(self.name.remove_chars("tick_"))
	var current_room = StationMap.rooms[current_index].instantiate()
	current_item = current_room.get_node("Pickup").target_item
	current_map = current_room.get_node("SaveStation").target_item
	if current_room.get_node("Button") != null:
		current_button = current_room.get_node("Button").target_item
		$button_tick.visible = true
	
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
			display_text = "WM"
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
	match(current_index):
		24:
			if Globals.map_mc:
				visible = true
			else:
				visible = false
		25:
			if Globals.map_ps:
				visible = true
			else:
				visible = false
		26:
			if Globals.map_pn:
				visible = true
			else:
				visible = false
		34:
			if Globals.map_oh:
				visible = true
			else:
				visible = false
		35:
			if Globals.map_rm:
				visible = true
			else:
				visible = false
		36:
			if Globals.map_wm:
				visible = true
			else:
				visible = false
		44:
			if Globals.map_h:
				visible = true
			else:
				visible = true
		45:
			if Globals.map_bf:
				visible = true
			else:
				visible = false
		46:
			if Globals.map_cs:
				visible = true
			else:
				visible = false
		54:
			if Globals.map_cd:
				visible = true
			else:
				visible = false
		55:
			if Globals.map_fw:
				visible = true
			else:
				visible = false
		56:
			if Globals.map_eb:
				visible = true
			else:
				visible = false
	
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
		17:
			item_status = Globals.map_mc
		18:
			item_status = Globals.map_ps
		19:
			item_status = Globals.map_pn
		20:
			item_status = Globals.map_oh
		21:
			item_status = Globals.map_rm
		22:
			item_status = Globals.map_wm
		23:
			item_status = Globals.map_h
		24:
			item_status = Globals.map_bf
		25:
			item_status = Globals.map_cs
		26:
			item_status = Globals.map_cd
		27:
			item_status = Globals.map_fw
		28:
			item_status = Globals.map_eb
	
	if not item_status:
		texture = box_texture[0]
	else:
		texture = box_texture[1]
	
	match(current_map):
		0:
			map_status = Globals.unlock_door
		1:
			map_status = Globals.unlock_hatch
		2:
			map_status = Globals.unlock_sheet
		3:
			map_status = Globals.unlock_iris
		4:
			map_status = Globals.unlock_vault
		5:
			map_status = Globals.unlock_roll
		6:
			map_status = Globals.unlock_jump
		7:
			map_status = Globals.unlock_walljump
		8:
			map_status = Globals.unlock_lateralboost
		9:
			map_status = Globals.unlock_downboost
		10:
			map_status = Globals.unlock_bounce
		11:
			map_status = Globals.unlock_grapple
		12:
			map_status = Globals.unlock_spin
		13:
			map_status = Globals.unlock_waterproofing
		14:
			map_status = Globals.unlock_energy_1
		15:
			map_status = Globals.unlock_energy_2
		16:
			map_status = Globals.unlock_heat
		17:
			map_status = Globals.map_mc
		18:
			map_status = Globals.map_ps
		19:
			map_status = Globals.map_pn
		20:
			map_status = Globals.map_oh
		21:
			map_status = Globals.map_rm
		22:
			map_status = Globals.map_wm
		23:
			map_status = Globals.map_h
		24:
			map_status = Globals.map_bf
		25:
			map_status = Globals.map_cs
		26:
			map_status = Globals.map_cd
		27:
			map_status = Globals.map_fw
		28:
			map_status = Globals.map_eb
	
	if not map_status:
		$map_tick.texture = box_texture[0]
	else:
		$map_tick.texture = box_texture[2]
	
	if current_button != null:
		match(current_button):
			0:
				button_status = Globals.unlock_door
			1:
				button_status = Globals.unlock_hatch
			2:
				button_status = Globals.unlock_sheet
			3:
				button_status = Globals.unlock_iris
			4:
				button_status = Globals.unlock_vault
			5:
				button_status = Globals.unlock_roll
			6:
				button_status = Globals.unlock_jump
			7:
				button_status = Globals.unlock_walljump
			8:
				button_status = Globals.unlock_lateralboost
			9:
				button_status = Globals.unlock_downboost
			10:
				button_status = Globals.unlock_bounce
			11:
				button_status = Globals.unlock_grapple
			12:
				button_status = Globals.unlock_spin
			13:
				button_status = Globals.unlock_waterproofing
			14:
				button_status = Globals.unlock_energy_1
			15:
				button_status = Globals.unlock_energy_2
			16:
				button_status = Globals.unlock_heat
			17:
				button_status = Globals.map_mc
			18:
				button_status = Globals.map_ps
			19:
				button_status = Globals.map_pn
			20:
				button_status = Globals.map_oh
			21:
				button_status = Globals.map_rm
			22:
				button_status = Globals.map_wm
			23:
				button_status = Globals.map_h
			24:
				button_status = Globals.map_bf
			25:
				button_status = Globals.map_cs
			26:
				button_status = Globals.map_cd
			27:
				button_status = Globals.map_fw
			28:
				button_status = Globals.map_eb
		
		if not button_status:
			$button_tick.texture = box_texture[0]
		else:
			$button_tick.texture = box_texture[2]
