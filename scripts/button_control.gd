extends Node3D

const y_pos_unpressed := 0.75
const y_pos_pressed := 0.0

@export var ui_text: Node3D
@export var ui_all: Node3D
@export var ui_element: Node3D
@export var raycast: RayCast3D

@export var button: Node3D
@export var pickup_trigger: Node3D

@export_enum(
	"unlock_door", "unlock_hatch", "unlock_sheet", "unlock_iris", "unlock_vault", 
	"unlock_roll", "unlock_jump", "unlock_walljump", "unlock_lateralboost", "unlock_downboost", 
	"unlock_bounce", "unlock_grapple", "unlock_spin", 
	"unlock_waterproofing", "unlock_energy_1", "unlock_energy_2", "unlock_heat", 
	"map_mc", "map_ps", "map_pn", "map_oh", "map_rm", "map_wm", 
	"map_h", "map_bf", "map_cs", "map_cd", "map_fw", "map_eb"
	) var target_item: int
@export var is_on_cieling: bool

var collected_state := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match(Globals.item_locations[target_item]):
		0:
			ui_text.text = "security_1"
			collected_state = Globals.unlock_door
		1:
			ui_text.text = "security_2"
			collected_state = Globals.unlock_hatch
		2:
			ui_text.text = "security_3"
			collected_state = Globals.unlock_sheet
		3:
			ui_text.text = "security_4"
			collected_state = Globals.unlock_iris
		4:
			ui_text.text = "security_5"
			collected_state = Globals.unlock_vault
		5:
			ui_text.text = "roll"
			collected_state = Globals.unlock_roll
		6:
			ui_text.text = "jump_floor"
			collected_state = Globals.unlock_jump
		7:
			ui_text.text = "jump_wall"
			collected_state = Globals.unlock_walljump
		8:
			ui_text.text = "boost_lateral"
			collected_state = Globals.unlock_lateralboost
		9:
			ui_text.text = "boost_down"
			collected_state = Globals.unlock_downboost
		10:
			ui_text.text = "bounce"
			collected_state = Globals.unlock_bounce
		11:
			ui_text.text = "grapple"
			collected_state = Globals.unlock_grapple
		12:
			ui_text.text = "spin"
			collected_state = Globals.unlock_spin
		13:
			ui_text.text = "swim"
			collected_state = Globals.unlock_waterproofing
		14:
			ui_text.text = "battery"
			collected_state = Globals.unlock_energy_1
		15:
			ui_text.text = "unlock_energy_2"
			collected_state = Globals.unlock_energy_2
		16:
			ui_text.text = "insulation"
			collected_state = Globals.unlock_heat
		17:
			ui_text.text = "map_mc"
			collected_state = Globals.map_mc
		18:
			ui_text.text = "map_ps"
			collected_state = Globals.map_ps
		19:
			ui_text.text = "map_pn"
			collected_state = Globals.map_pn
		20:
			ui_text.text = "map_oh"
			collected_state = Globals.map_oh
		21:
			ui_text.text = "map_rm"
			collected_state = Globals.map_rm
		22:
			ui_text.text = "map_wm"
			collected_state = Globals.map_wm
		23:
			ui_text.text = "map_h"
			collected_state = Globals.map_h
		24:
			ui_text.text = "map_bf"
			collected_state = Globals.map_bf
		25:
			ui_text.text = "map_cs"
			collected_state = Globals.map_cs
		26:
			ui_text.text = "map_cd"
			collected_state = Globals.map_cd
		27:
			ui_text.text = "map_fw"
			collected_state = Globals.map_fw
		28:
			ui_text.text = "map_eb"
			collected_state = Globals.map_eb
	
	if collected_state:
		ui_element.visible = false
		$OmniLight3D.visible = false
		button.position.y = 0
		pickup_trigger.position.y = -0.2
	else:
		button.position.y = 0.75
		pickup_trigger.position.y = 1
		

func _process(delta: float) -> void:
	if not collected_state:
		ui_all.look_at(Globals.player.global_position)
		var distance_to_player = ui_all.global_position.distance_to(Globals.player.global_position)
		if raycast.is_colliding() and raycast.get_collider() == Globals.player:
			ui_element.position.z = -distance_to_player + 0.11
			ui_element.position.y = -Globals.player.reticle.position.y/randi_range(16,22) + 0.01 + (-0.0001 * distance_to_player)
			ui_element.position.x = Globals.player.reticle.position.x/randi_range(14,22) - 0.01 - (-0.0001 * distance_to_player)
		else:
			ui_element.position = Vector3.ZERO

func _on_pickup_trigger_body_entered(body: Node3D) -> void:
	var speed_check
	var player_velocity_y = body.velocity.y
	if is_on_cieling:
		speed_check = 6
	else:
		speed_check = 24
		player_velocity_y = -player_velocity_y
	if player_velocity_y > speed_check or body.state_downboosting:
		match(Globals.item_locations[target_item]):
			0:
				Globals.unlock_door = true
			1:
				Globals.unlock_hatch = true
			2:
				Globals.unlock_sheet = true
			3:
				Globals.unlock_iris = true
			4:
				Globals.unlock_vault = true
			5:
				Globals.unlock_roll = true
			6:
				Globals.unlock_jump = true
			7:
				Globals.unlock_walljump = true
			8:
				Globals.unlock_lateralboost = true
			9:
				Globals.unlock_downboost = true
			10:
				Globals.unlock_bounce = true
			11:
				Globals.unlock_grapple = true
			12:
				Globals.unlock_spin = true
			13:
				Globals.unlock_waterproofing = true
			14:
				Globals.unlock_energy_1 = true
			15:
				Globals.unlock_energy_2 = true
			16:
				Globals.unlock_heat = true
			17:
				Globals.map_mc = true
			18:
				Globals.map_ps = true
			19:
				Globals.map_pn = true
			20:
				Globals.map_oh = true
			21:
				Globals.map_rm = true
			22:
				Globals.map_wm = true
			23:
				Globals.map_h = true
			24:
				Globals.map_bf = true
			25:
				Globals.map_cs = true
			26:
				Globals.map_cd = true
			27:
				Globals.map_fw = true
			28:
				Globals.map_eb = true
		
		Globals.save_game()
		ui_element.visible = false
		$OmniLight3D.visible = false
		button.position.y = 0
		pickup_trigger.position.y = -0.2
