extends Node3D

var hover_collider = null

func _process(_delta: float) -> void:
	if owner.state_dead and not $DeadDrone.playing:
		$DeadDrone.play()
	elif not owner.state_dead and $DeadDrone.playing:
		$DeadDrone.stop()
	
	if owner.pilot_cast.is_colliding():
		if owner.pilot_cast.get_collider() != hover_collider:
			$MenuHover.play()
			hover_collider = owner.pilot_cast.get_collider()
		elif Input.is_action_just_pressed("fire"):
			if owner.pilot_cast.get_collider() == owner.estop_button_body:
				if owner.state_dead:
					$ButtonUp.play()
				else:
					$ButtonDown.play()
			else:
				$MenuClick.play()
	else:
		hover_collider = null
	
	if not owner.state_dead:
		if not owner.state_rolling:
			if owner.is_on_floor() and Input.get_vector("left", "right", "forward", "back") != Vector2.ZERO:
				if not $Walk.playing:
					$Walk.play()
			else:
				$Walk.stop()
			
			if Input.is_action_just_pressed("jump") and not owner.coyote_timer.is_stopped() and Globals.unlock_jump:
				$Jump.play()
		else:
			if $Walk.playing:
				$Walk.stop()
		
		if not owner.regrab_timer.is_stopped() and (Input.is_action_pressed("jump") or Input.is_action_pressed("boost")):
			if not $Thrust.playing:
				$Thrust.play()
		elif not owner.regrab_timer.is_stopped():
			$Thrust.stop()
