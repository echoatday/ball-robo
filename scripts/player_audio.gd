extends Node3D

var hover_collider = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if owner.pilot_cast.is_colliding() and owner.pilot_cast.get_collider() != hover_collider:
		$MenuHover.play()
		hover_collider = owner.pilot_cast.get_collider()
	elif owner.pilot_cast.is_colliding():
		pass
	else:
		hover_collider = null
		
	
	if owner.pilot_cast.get_collider() == owner.estop_button_body:
		pass
