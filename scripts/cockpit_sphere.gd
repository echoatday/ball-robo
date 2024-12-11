extends Node3D

@onready var look_target = owner.camera.position
@onready var base_ico_transform := icosphere.transform
@export var icosphere: Node3D
@export var screen: Array[Node3D]
@export var walk_sphere: Node3D
var count := 41

func _physics_process(delta: float) -> void:
		
	if owner.state_dead:
		if count == 41:
			screen.shuffle()
			count -= 1
		elif count >= 0 and Engine.get_physics_frames() % 2 == 0:
			screen[count-1].visible = true
			count -= 1
		elif count >= 0 and Engine.get_physics_frames() % 2 != 0:
			screen[40-count-1].visible = true
			count -= 1
	else:
		if count == -1:
			screen.shuffle()
			count += 1
		elif count <= 40 and Engine.get_physics_frames() % 2 == 0:
			screen[count-1].visible = false
			count += 1
		elif count <= 40 and Engine.get_physics_frames() % 2 != 0:
			screen[40-count-1].visible = false
			count += 1
		else:
			if owner.state_looking:
				look_at(look_target)
			if not owner.state_rolling:
				walk_sphere.visible = true
			else:
				walk_sphere.visible = false
	
	look_target = owner.camera.project_position((get_viewport().get_mouse_position()/9)+Vector2(get_viewport().size/2.25),10)
	
	transform.origin = owner.transform.origin
	if !owner.state_rolling:
		icosphere.transform =  base_ico_transform
	else:
		if owner.is_on_floor():
			icosphere.global_rotate(Vector3(owner.velocity.z, 0, -owner.velocity.x).normalized(), 0.01*owner.velocity.length())
		else:
			icosphere.global_rotate(Vector3(owner.velocity.z, 0, -owner.velocity.x).normalized(), 0.005*owner.velocity.length())
