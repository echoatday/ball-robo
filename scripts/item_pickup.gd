extends Node3D

var unlock_roll := true
var unlock_jump := true
var unlock_walljump := true
var unlock_lateralboost := true
var unlock_downboost := true
var unlock_bounce := true
var unlock_grapple := true
var unlock_spin := true
var unlock_waterproofing := true

var unlock_energy_1 := true
var unlock_energy_2 := true
var unlock_heat := true

@export_enum("unlock_door", "unlock_hatch", "unlock_sheet", "unlock_iris", "unlock_vault", "unlock_roll", "unlock_jump", "unlock_walljump", "unlock_lateralboost", "unlock_downboost", "unlock_bounce", "unlock_grapple", "unlock_spin", "unlock_waterproofing", "unlock_energy_1", "unlock_energy_2", "unlock_heat") var target_item: int

# do this the same as button but just pickup on body entered no check

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pickup_trigger_body_entered(body: Node3D) -> void:
	pass # Replace with function body.
