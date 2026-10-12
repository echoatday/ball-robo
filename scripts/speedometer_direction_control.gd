extends Node3D

@export var speedometer_base: Node3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	position = speedometer_base.position
	
	var my_velocity
	if owner.state_bouncing:
		my_velocity = owner.get_velocity()
	else:
		my_velocity = owner.get_real_velocity()
	if Engine.get_physics_frames() % 2 == 0:
		if my_velocity != Vector3.ZERO:
			look_at(global_position + my_velocity)
		else:
			look_at(owner.global_position)
		rotation_degrees.y -= 40
		scale.z = clamp(my_velocity.length()*0.1,0,0.5)
