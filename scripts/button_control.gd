extends Node3D

const y_pos_unpressed := 0.75
const y_pos_pressed := 0.0

@export var button: Node3D
@export var pickup_trigger: Node3D

@export_enum("doors_rawmaterials", "doors_blastfurnace") var target_item: int
@export var is_on_cieling: bool

var collected_state := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match(target_item):
		0:
			collected_state = Globals.doors_rawmaterials
		1:
			collected_state = Globals.doors_blastfurnace
	
	if collected_state:
		button.position.y = 0
		pickup_trigger.position.y = -0.2
	else:
		button.position.y = 0.75
		pickup_trigger.position.y = 1
		


func _on_pickup_trigger_body_entered(body: Node3D) -> void:
	var speed_check
	var player_velocity_y = body.velocity.y
	print(player_velocity_y)
	if is_on_cieling:
		speed_check = 6
	else:
		speed_check = 10
		player_velocity_y = -player_velocity_y
	if player_velocity_y > speed_check:
		match(target_item):
			0:
				Globals.doors_rawmaterials = true
			1:
				Globals.doors_blastfurnace = true
		Globals.save_game()
		button.position.y = 0
		pickup_trigger.position.y = -0.2
