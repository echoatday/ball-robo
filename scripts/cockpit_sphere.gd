extends Node3D

@onready var look_target = owner.camera.position
@export var icosphere: Node3D
@onready var base_ico_transform := icosphere.transform

func _physics_process(delta: float) -> void:
	look_target = owner.camera.project_position((get_viewport().get_mouse_position()/9)+Vector2(get_viewport().size/2.25),10)
	
	if owner.state_looking:
		look_at_target_interpolated(0.5)
	
	transform.origin = owner.transform.origin
	if !owner.state_rolling:
		icosphere.transform =  icosphere.transform.interpolate_with(base_ico_transform, 0.1)
	else:
		if owner.is_on_floor():
			icosphere.global_rotate(Vector3(owner.velocity.z, 0, -owner.velocity.x).normalized(), 0.01*owner.velocity.length())
		else:
			icosphere.global_rotate(Vector3(owner.velocity.z, 0, -owner.velocity.x).normalized(), 0.005*owner.velocity.length())

func look_at_target_interpolated(weight:float) -> void:
	var xform := transform
	xform = xform.looking_at(look_target,Vector3.UP)
	transform = transform.interpolate_with(xform,weight)
