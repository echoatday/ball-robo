extends Node3D

@onready var look_target = owner.camera.position
@onready var base_ico_transform := icosphere.transform
@export var icosphere: Node3D
@export var screen: Array[Node3D]
var count := 40

func _physics_process(delta: float) -> void:
	
	if owner.state_looking:
		look_at_target_interpolated(0.5)
	
	if not owner.state_rolling:
		pass
		
	if owner.state_dead:
		if count == 40:
			screen.shuffle()
			screen[count-1].visible = true
			count -= 1
		if count >= 0 and Engine.get_physics_frames() % 8 == 0:
			screen[count-1].visible = true
			count -= 1
		elif count >= 0 and Engine.get_physics_frames() % 4 == 0:
			screen[40-count-1].visible = true
			count -= 1
	else:
		count = 40
	
	look_target = owner.camera.project_position((get_viewport().get_mouse_position()/9)+Vector2(get_viewport().size/2.25),10)
	
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
