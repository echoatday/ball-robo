extends CSGTorus3D

var walk_transition := false

func _physics_process(delta: float) -> void:
	if owner.state_rolling:
		if owner.state_spinning:
			rotate_x(-owner.spin_velocity.length() * 0.01)
		else:
			walk_transition = false
			rotation_degrees.x = move_toward(rotation_degrees.x, 0, 2)
	if Input.is_action_just_pressed("roll"):
		walk_transition = true
	
	if walk_transition:
		rotation_degrees.x = move_toward(rotation_degrees.x, 90, 2)
		if rotation_degrees.x == 90:
			walk_transition = false
