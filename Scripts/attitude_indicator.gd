extends CSGSphere3D

func _physics_process(delta: float) -> void:
	var rotation = get_parent().rotation_degrees.y + 90
	self.global_rotation_degrees = Vector3(0,0+rotation,0)
	pass
