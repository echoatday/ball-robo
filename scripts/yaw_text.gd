extends Label3D

func _physics_process(delta: float) -> void:
	var meter_yaw = owner.global_rotation_degrees.y
	var yaw_time = (-meter_yaw-90)
	if yaw_time < 0:
		yaw_time += 360
	text = str(yaw_time).pad_zeros(3).pad_decimals(0)
