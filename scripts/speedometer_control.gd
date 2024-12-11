extends Label3D

func _physics_process(delta: float) -> void:
	var meter_speed = snapped(owner.velocity.length(),0.1)
	if meter_speed > 99.6:
		text = str("99.6")
	else:
			text = str(meter_speed).pad_decimals(1)
	pass
