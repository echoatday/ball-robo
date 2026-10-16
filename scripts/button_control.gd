extends Node3D

const y_pos_unpressed := 0.75
const y_pos_pressed := 0.0

@export var button: Node3D
@export var pickup_trigger: Node3D

@export_enum("unlock_door", "unlock_hatch", "unlock_sheet", "unlock_iris", "unlock_vault", "unlock_roll", "unlock_jump", "unlock_walljump", "unlock_lateralboost", "unlock_downboost", "unlock_bounce", "unlock_grapple", "unlock_spin", "unlock_waterproofing", "unlock_energy_1", "unlock_energy_2", "unlock_heat") var target_item: int
@export var is_on_cieling: bool

var collected_state := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match(target_item):
		0:
			collected_state = Globals.unlock_door
		1:
			collected_state = Globals.unlock_hatch
		2:
			collected_state = Globals.unlock_sheet
		3:
			collected_state = Globals.unlock_iris
		4:
			collected_state = Globals.unlock_vault
		5:
			collected_state = Globals.unlock_roll
		6:
			collected_state = Globals.unlock_jump
		7:
			collected_state = Globals.unlock_walljump
		8:
			collected_state = Globals.unlock_lateralboost
		9:
			collected_state = Globals.unlock_downboost
		10:
			collected_state = Globals.unlock_bounce
		11:
			collected_state = Globals.unlock_grapple
		12:
			collected_state = Globals.unlock_spin
		13:
			collected_state = Globals.unlock_waterproofing
		14:
			collected_state = Globals.unlock_energy_1
		15:
			collected_state = Globals.unlock_energy_2
		16:
			collected_state = Globals.unlock_heat
	
	if collected_state:
		button.position.y = 0
		pickup_trigger.position.y = -0.2
	else:
		button.position.y = 0.75
		pickup_trigger.position.y = 1
		


func _on_pickup_trigger_body_entered(body: Node3D) -> void:
	var speed_check
	var player_velocity_y = body.velocity.y
	if is_on_cieling:
		speed_check = 6
	else:
		speed_check = 24
		player_velocity_y = -player_velocity_y
	if player_velocity_y > speed_check or body.state_downboosting:
		match(target_item):
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
		Globals.save_game()
		button.position.y = 0
		pickup_trigger.position.y = -0.2
