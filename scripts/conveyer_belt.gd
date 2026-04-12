extends StaticBody3D

@export var belt_mesh: Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var belt_rotation = get_global_rotation_degrees()
	var belt_velocity = Vector3.ZERO
	if belt_rotation.y > -45 and belt_rotation.y < 45:
		belt_velocity.x = -8
	elif belt_rotation.y > 45 and belt_rotation.y < 135:
		belt_velocity.z = 8
	elif belt_rotation.y < -45 and belt_rotation.y > -135:
		belt_velocity.z = -8
	else:
		belt_velocity.x = 8
	set_constant_linear_velocity(belt_velocity)
	
	belt_mesh.get_active_material(2).uv1_scale.y = self.scale.x*1.2
	belt_mesh.get_active_material(0).uv1_scale.y = self.scale.x*1.2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	belt_mesh.get_active_material(2).uv1_offset.y += 0.02
	belt_mesh.get_active_material(1).uv1_offset.y += 0.1
	pass
