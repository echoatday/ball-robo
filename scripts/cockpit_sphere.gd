extends Node3D

func _physics_process(delta: float) -> void:
	transform.origin = owner.transform.origin
	if !owner.state_rolling:
		look_at(owner.camera.project_position((get_viewport().get_mouse_position()/9)+Vector2(get_viewport().size/2.25),10))
