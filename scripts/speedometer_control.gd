extends Label3D

func _physics_process(delta: float) -> void:
	var meter_speed = snapped(owner.velocity.length(),0.1)
	if Engine.get_physics_frames() % 2 == 0:
			text = str(meter_speed).pad_decimals(1)
