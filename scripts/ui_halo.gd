extends Node3D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	global_rotation = Vector3.ZERO
	
	if owner.state_rolling:
		if owner.is_on_floor():
			self.mesh.material.stencil_outline_thickness = 0.001
			self.mesh.radius = 0.3
			self.mesh.height = 1
		else:
			self.mesh.material.stencil_outline_thickness = 0.003
			self.mesh.radius = 1.5
			self.mesh.height = 3
	else:
		if owner.is_on_floor():
			self.mesh.material.stencil_outline_thickness = 0.002
			self.mesh.radius = 0.8
			self.mesh.height = 2
		elif owner.is_on_wall():
			self.mesh.material.stencil_outline_thickness = 0.0005
			self.mesh.radius = 0.91
			self.mesh.height = 1.88
		else:
			self.mesh.material.stencil_outline_thickness = 0.006
			self.mesh.radius = 3
			self.mesh.height = 6
