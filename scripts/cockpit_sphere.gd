extends Node3D

func _physics_process(delta: float) -> void:
	transform.origin = owner.transform.origin
	if !owner.state_rolling:
		look_at(owner.camera.project_position((get_viewport().get_mouse_position()/9)+Vector2(get_viewport().size/2.25),10))
	else:
		if owner.is_on_floor():
			global_rotate(Vector3(owner.velocity.z, 0, -owner.velocity.x).normalized(), 0.01*owner.velocity.length())
		else:
			global_rotate(Vector3(owner.velocity.z, 0, -owner.velocity.x).normalized(), 0.005*owner.velocity.length())
