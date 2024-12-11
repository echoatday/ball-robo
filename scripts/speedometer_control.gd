extends Label3D

func _physics_process(delta: float) -> void:
	var meter_speed = snapped(owner.velocity.length(),0.1)
	if meter_speed > 99.6:
		text = str("99.6")
	elif Engine.get_physics_frames() % 10 == 0:
			text = str(meter_speed).pad_decimals(1)
	pass
