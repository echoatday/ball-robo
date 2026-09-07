extends MeshInstance3D

func _physics_process(_delta: float) -> void:
	rotation_degrees.y = -owner.rotation_degrees.y + 1
