extends Label3D

@export var sphere: Node3D

func _physics_process(delta: float) -> void:
	var meter_roll = snapped(sphere.global_rotation_degrees.x,1)
	text = str(meter_roll).pad_zeros(2)
