extends Label3D

func _physics_process(delta: float) -> void:
	var meter_height = snapped(owner.global_position.y,0.1) + 0.1
	text = str(meter_height).pad_zeros(2).pad_decimals(1)
