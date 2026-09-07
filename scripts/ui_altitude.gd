extends MeshInstance3D

func _physics_process(_delta: float) -> void:
	position.y = (-owner.position.y/100)-0.003
