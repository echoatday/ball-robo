extends Node3D

@export var save_trigger := Area3D
@export_enum(
	"error:24", "power_shovel:25", "null:26",
	"outer_hull:34","raw_materials:35","waste_disposal:36",
	"habitation:44","blast_furnace:45","cooling_system:46",
	"control_deck:54","forge_works:55","engine_block:56"
) var level_id: int

func _on_save_trigger_body_entered(body: Node3D) -> void:
	Globals.current_checkpoint = level_id
	Globals.rolled_state = body.state_rolling
	Globals.save_game()
