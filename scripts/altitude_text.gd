extends Label3D

func _physics_process(delta: float) -> void:
	var meter_height = snapped(owner.global_position.y,0.1) + 0.1
	text = str((meter_height+66.6)*10).pad_zeros(3).pad_decimals(0)
