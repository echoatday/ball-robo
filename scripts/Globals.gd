extends Node

var player: CharacterBody3D
@onready var world = get_tree().current_scene

# nothing, cube, brain
var holding_item := 0
# cube_rm, cube_cd, brain_home
var pickup_locations := [1, 0, 2]
var self_destruct := false

var current_checkpoint: int
var rolled_state := false
var pipenetwork_state := false

var item_locations: Array[int] = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28]

var unlock_door := false
var unlock_hatch := false
var unlock_sheet := false
var unlock_iris := true
var unlock_vault := true

var unlock_roll := true
var unlock_jump := true
var unlock_walljump := true
var unlock_lateralboost := true
var unlock_downboost := true
var unlock_bounce := true
var unlock_grapple := true
var unlock_spin := true
var unlock_waterproofing := true

var map_mc := false
var map_ps := false
var map_pn := false
var map_oh := false
var map_rm := false
var map_wm := false
var map_h := false
var map_bf := false
var map_cs := false
var map_cd := false
var map_fw := false
var map_eb := false

var unlock_energy_1 := true
var unlock_energy_2 := true
var unlock_heat := true

func save_game():
	var save_dict = {
		"item_locations" : item_locations,
		"current_checkpoint" : current_checkpoint,
		"rolled_state" : rolled_state,
		"pipenetwork_state" : pipenetwork_state,
		
		"unlock_door" : unlock_door,
		"unlock_hatch" : unlock_hatch,
		"unlock_sheet" : unlock_sheet,
		"unlock_iris" : unlock_iris,
		"unlock_vault" : unlock_vault,
		
		"unlock_roll" : unlock_roll,
		"unlock_jump" : unlock_jump,
		"unlock_walljump" : unlock_walljump,
		"unlock_lateralboost" : unlock_lateralboost,
		"unlock_downboost" : unlock_downboost,
		"unlock_bounce" : unlock_bounce,
		"unlock_grapple" : unlock_grapple,
		"unlock_spin" : unlock_spin,
		"unlock_waterproofing": unlock_waterproofing,
		
		"unlock_energy_1" : unlock_energy_1,
		"unlock_energy_2" : unlock_energy_2,
		"unlock_heat" : unlock_heat,
		
		"map_mc" : map_mc,
		"map_ps" : map_ps,
		"map_pn" : map_pn,
		"map_oh" : map_oh,
		"map_rm" : map_rm,
		"map_wm" : map_wm,
		"map_h" : map_h,
		"map_bf" : map_bf,
		"map_cs" : map_cs,
		"map_cd" : map_cd,
		"map_fw" : map_fw,
		"map_eb" : map_eb
	}
	var json_string = JSON.stringify(save_dict)
	var save_file = FileAccess.open("res://saves/savegame.json", FileAccess.WRITE)
	save_file.store_line(json_string)
	if unlock_energy_1 and unlock_energy_2:
		player.max_energy = 500
	elif Globals.unlock_energy_1 or Globals.unlock_energy_2:
		player.max_energy = 400
	else:
		player.max_energy = 300
	email_display()

func load_game():
	self_destruct = false
	item_locations = [1, 0, 2]
	holding_item = 0
	if not FileAccess.file_exists("res://saves/savegame.json"):
		return # Error! We don't have a save to load.
	var save_file = FileAccess.open("res://saves/savegame.json", FileAccess.READ)
	var json = JSON.new()
	var _parse_result = json.parse(save_file.get_as_text())
	
	item_locations.assign(json.data["item_locations"])
	
	current_checkpoint = json.data["current_checkpoint"]
	rolled_state = json.data["rolled_state"]
	pipenetwork_state = json.data["pipenetwork_state"]
	
	unlock_door = json.data["unlock_door"]
	unlock_hatch = json.data["unlock_hatch"]
	unlock_sheet = json.data["unlock_sheet"]
	unlock_iris = json.data["unlock_iris"]
	unlock_vault = json.data["unlock_vault"]
	
	unlock_roll = json.data["unlock_roll"]
	unlock_jump = json.data["unlock_jump"]
	unlock_walljump = json.data["unlock_walljump"]
	unlock_lateralboost = json.data["unlock_lateralboost"]
	unlock_downboost = json.data["unlock_downboost"]
	unlock_bounce = json.data["unlock_bounce"]
	unlock_grapple = json.data["unlock_grapple"]
	unlock_spin = json.data["unlock_spin"]
	
	unlock_energy_1 = json.data["unlock_energy_1"]
	unlock_energy_2 = json.data["unlock_energy_2"]
	unlock_heat = json.data["unlock_heat"]
	unlock_waterproofing = json.data["unlock_waterproofing"]
	
	map_mc = json.data["map_mc"]
	map_ps = json.data["map_ps"]
	map_pn = json.data["map_pn"]
	map_oh = json.data["map_oh"]
	map_rm = json.data["map_rm"]
	map_wm = json.data["map_wm"]
	map_h = json.data["map_h"]
	map_bf = json.data["map_bf"]
	map_cs = json.data["map_cs"]
	map_cd = json.data["map_cd"]
	map_fw = json.data["map_fw"]
	map_eb = json.data["map_eb"]
	
	player.state_rolling = rolled_state
	
	var instance = StationMap.rooms[current_checkpoint].instantiate()
	var instance_checkpoint_transform = instance.find_child("SaveStation").transform
	for child in world.get_children():
		if child != player:
			world.remove_child(child)
	world.add_child(instance)
	return(instance_checkpoint_transform)


var input_forward: InputEvent = str_to_var("InputEventKey: keycode=87 (W), mods=none, physical=false, location=unspecified, pressed=true, echo=false")
var input_back: InputEvent = str_to_var("InputEventKey: keycode=83 (S), mods=none, physical=false, location=unspecified, pressed=true, echo=false")
var input_left: InputEvent = str_to_var("InputEventKey: keycode=65 (A), mods=none, physical=false, location=unspecified, pressed=true, echo=false")
var input_right: InputEvent = str_to_var("InputEventKey: keycode=68 (D), mods=none, physical=false, location=unspecified, pressed=true, echo=false")
var input_jump: InputEvent = str_to_var("InputEventKey: keycode=32 (Space), mods=none, physical=false, location=unspecified, pressed=true, echo=false")
var input_boost: InputEvent = str_to_var("InputEventKey: keycode=4194325 (Shift), mods=none, physical=false, location=left, pressed=true, echo=false")
var input_roll: InputEvent = str_to_var("InputEventKey: keycode=82 (R), mods=none, physical=false, location=unspecified, pressed=true, echo=false")
var input_fire: InputEvent = str_to_var("InputEventMouseButton: button_index=1, mods=none, pressed=true, canceled=false, position=((598.0, 336.0)), button_mask=1, double_click=false")
var input_look: InputEvent = str_to_var("InputEventMouseButton: button_index=2, mods=none, pressed=true, canceled=false, position=((598.0, 336.0)), button_mask=2, double_click=false")
var input_lookup: InputEvent = str_to_var("InputEventKey: keycode=4194320 (Up), mods=none, physical=false, location=unspecified, pressed=true, echo=false")
var input_lookdown: InputEvent = str_to_var("InputEventKey: keycode=4194322 (Down), mods=none, physical=false, location=unspecified, pressed=true, echo=false")
var input_lookleft: InputEvent = str_to_var("InputEventKey: keycode=4194319 (Left), mods=none, physical=false, location=unspecified, pressed=true, echo=false")
var input_lookright: InputEvent = str_to_var("InputEventKey: keycode=4194321 (Right), mods=none, physical=false, location=unspecified, pressed=true, echo=false")
var mouse_sensitivity := 1.0
var volume_inside := 10
var volume_outside := 10
var volume_music := 10
var max_framerate := 60
var resolution_scale := 1.0
var windowed_mode := 3

func save_options():
	var save_dict = {
		"input_forward" : var_to_str(input_forward),
		"input_back" : var_to_str(input_back),
		"input_left" : var_to_str(input_left),
		"input_right" : var_to_str(input_right),
		"input_jump" : var_to_str(input_jump),
		"input_boost" : var_to_str(input_boost),
		"input_roll" : var_to_str(input_roll),
		"input_fire" : var_to_str(input_fire),
		"input_look" : var_to_str(input_look),
		"input_lookup" : var_to_str(input_lookup),
		"input_lookdown" : var_to_str(input_lookdown),
		"input_lookleft" : var_to_str(input_lookleft),
		"input_lookright" : var_to_str(input_lookright),
		"mouse_sensitivity" : mouse_sensitivity,
		"volume_inside" : volume_inside,
		"volume_outside" : volume_outside,
		"volume_music" : volume_music,
		"max_framerate" : max_framerate,
		"resolution_scale" : resolution_scale,
		"windowed_mode" : windowed_mode
	}
	var json_string = JSON.stringify(save_dict)
	var save_file = FileAccess.open("res://saves/options.json", FileAccess.WRITE)
	save_file.store_line(json_string)

func load_options():
	if not FileAccess.file_exists("res://saves/options.json"):
		return
	var options_file = FileAccess.open("res://saves/options.json", FileAccess.READ)
	var json = JSON.new()
	var _parse_result = json.parse(options_file.get_as_text())
	input_forward = str_to_var(json.data["input_forward"])
	input_back = str_to_var(json.data["input_back"])
	input_left = str_to_var(json.data["input_left"])
	input_right = str_to_var(json.data["input_right"])
	input_jump = str_to_var(json.data["input_jump"])
	input_boost = str_to_var(json.data["input_boost"])
	input_roll = str_to_var(json.data["input_roll"])
	input_fire = str_to_var(json.data["input_fire"])
	input_look = str_to_var(json.data["input_look"])
	input_lookup = str_to_var(json.data["input_lookup"])
	input_lookdown = str_to_var(json.data["input_lookdown"])
	input_lookleft = str_to_var(json.data["input_lookleft"])
	input_lookright = str_to_var(json.data["input_lookright"])
	mouse_sensitivity = json.data["mouse_sensitivity"]
	volume_inside = json.data["volume_inside"]
	volume_outside = json.data["volume_outside"]
	volume_music = json.data["volume_music"]
	max_framerate = json.data["max_framerate"]
	resolution_scale = json.data["resolution_scale"]
	windowed_mode = json.data["windowed_mode"]
	
	Engine.max_fps = max_framerate
	get_viewport().scaling_3d_scale = resolution_scale
	DisplayServer.window_set_mode(windowed_mode)
	InputMap.action_erase_events("forward")
	InputMap.action_add_event("forward",input_forward)
	InputMap.action_erase_events("back")
	InputMap.action_add_event("back",input_back)
	InputMap.action_erase_events("left")
	InputMap.action_add_event("left",input_left)
	InputMap.action_erase_events("right")
	InputMap.action_add_event("right",input_right)
	InputMap.action_erase_events("jump")
	InputMap.action_add_event("jump",input_jump)
	InputMap.action_erase_events("boost")
	InputMap.action_add_event("boost",input_boost)
	InputMap.action_erase_events("roll")
	InputMap.action_add_event("roll",input_roll)
	InputMap.action_erase_events("fire")
	InputMap.action_add_event("fire",input_fire)
	InputMap.action_erase_events("look")
	InputMap.action_add_event("look",input_look)
	InputMap.action_erase_events("lookup")
	InputMap.action_add_event("lookup",input_lookup)
	InputMap.action_erase_events("lookdown")
	InputMap.action_add_event("lookdown",input_lookdown)
	InputMap.action_erase_events("lookleft")
	InputMap.action_add_event("lookleft",input_lookleft)
	InputMap.action_erase_events("lookright")
	InputMap.action_add_event("lookright",input_lookright)

func email_display():
	if unlock_jump:
		player.email_reference.emails[0].visible = true
		player.email_reference.emails[0].collision.set_collision_layer_value(4,true)
	else:
		player.email_reference.emails[0].visible = false
		player.email_reference.emails[0].collision.set_collision_layer_value(4,false)
	if unlock_roll:
		player.email_reference.emails[1].visible = true
		player.email_reference.emails[1].collision.set_collision_layer_value(4,true)
	else:
		player.email_reference.emails[1].visible = false
		player.email_reference.emails[1].collision.set_collision_layer_value(4,false)
	if unlock_bounce:
		player.email_reference.emails[2].visible = true
		player.email_reference.emails[2].collision.set_collision_layer_value(4,true)
	else:
		player.email_reference.emails[2].visible = false
		player.email_reference.emails[2].collision.set_collision_layer_value(4,false)
	if unlock_walljump:
		player.email_reference.emails[3].visible = true
		player.email_reference.emails[3].collision.set_collision_layer_value(4,true)
	else:
		player.email_reference.emails[3].visible = false
		player.email_reference.emails[3].collision.set_collision_layer_value(4,false)
	if unlock_heat:
		player.email_reference.emails[4].visible = true
		player.email_reference.emails[4].collision.set_collision_layer_value(4,true)
	else:
		player.email_reference.emails[4].visible = false
		player.email_reference.emails[4].collision.set_collision_layer_value(4,false)
	if unlock_grapple:
		player.email_reference.emails[5].visible = true
		player.email_reference.emails[5].collision.set_collision_layer_value(4,true)
	else:
		player.email_reference.emails[5].visible = false
		player.email_reference.emails[5].collision.set_collision_layer_value(4,false)
	if unlock_waterproofing:
		player.email_reference.emails[6].visible = true
		player.email_reference.emails[6].collision.set_collision_layer_value(4,true)
	else:
		player.email_reference.emails[6].visible = false
		player.email_reference.emails[6].collision.set_collision_layer_value(4,false)
	if unlock_lateralboost:
		player.email_reference.emails[7].visible = true
		player.email_reference.emails[7].collision.set_collision_layer_value(4,true)
	else:
		player.email_reference.emails[7].visible = false
		player.email_reference.emails[7].collision.set_collision_layer_value(4,false)
	if unlock_downboost:
		player.email_reference.emails[8].visible = true
		player.email_reference.emails[8].collision.set_collision_layer_value(4,true)
	else:
		player.email_reference.emails[8].visible = false
		player.email_reference.emails[8].collision.set_collision_layer_value(4,false)
	if unlock_spin:
		player.email_reference.emails[9].visible = true
		player.email_reference.emails[9].collision.set_collision_layer_value(4,true)
	else:
		player.email_reference.emails[9].visible = false
		player.email_reference.emails[9].collision.set_collision_layer_value(4,false)
	if unlock_vault:
		player.email_reference.emails[10].visible = true
		player.email_reference.emails[10].collision.set_collision_layer_value(4,true)
	else:
		player.email_reference.emails[10].visible = false
		player.email_reference.emails[10].collision.set_collision_layer_value(4,false)
	if unlock_iris:
		player.email_reference.emails[11].visible = true
		player.email_reference.emails[11].collision.set_collision_layer_value(4,true)
	else:
		player.email_reference.emails[11].visible = false
		player.email_reference.emails[11].collision.set_collision_layer_value(4,false)
