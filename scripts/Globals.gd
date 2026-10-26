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

func load_game():
	self_destruct = false
	item_locations = [1, 0, 2]
	holding_item = 0
	if not FileAccess.file_exists("res://saves/savegame.json"):
		return # Error! We don't have a save to load.
	var save_file = FileAccess.open("res://saves/savegame.json", FileAccess.READ)
	var json = JSON.new()
	var parse_result = json.parse(save_file.get_as_text())
	
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
