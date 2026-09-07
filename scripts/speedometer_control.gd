extends Label3D

func _physics_process(_delta: float) -> void:
	var my_velocity
	if owner.state_bouncing:
		my_velocity = owner.get_velocity()
	else:
		my_velocity = owner.get_real_velocity()
	var meter_speed = snapped(my_velocity.length(),0.1)
	if Engine.get_physics_frames() % 2 == 0:
			text = str(meter_speed).pad_decimals(1)
