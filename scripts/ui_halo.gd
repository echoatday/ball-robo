extends Node3D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	global_rotation = Vector3.ZERO
	
	if owner.state_rolling:
		if owner.is_on_floor():
			pass
		else:
			pass
		self.mesh.material.stencil_outline_thickness = 0.003
		self.mesh.radius = 0.65
		self.mesh.height = 1.3
	else:
		if owner.is_on_wall() or owner.is_on_floor():
			pass
		else:
			pass
		self.mesh.material.stencil_outline_thickness = 0.006
		self.mesh.radius = 1.5
		self.mesh.height = 3
