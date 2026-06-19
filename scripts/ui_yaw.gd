extends MeshInstance3D

func _physics_process(delta: float) -> void:
	rotation.y = -owner.rotation.y
