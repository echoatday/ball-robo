extends Node3D

var hover_collider = null

func _process(delta: float) -> void:
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
			if Input.is_action_just_pressed("roll"):
				$RollStart.play()
				$GrappleEnd.play()
			
			if $RollScrape.playing:
				$RollScrape.stop()
			
			if owner.is_on_floor() and Input.get_vector("left", "right", "forward", "back") != Vector2.ZERO:
				if not $Walk.playing:
					$Walk.play()
			else:
				$Walk.stop()
			
			if owner.is_on_wall() and Globals.unlock_walljump and not owner.velocity.is_zero_approx():
				$WallScrape.pitch_scale = clampf(owner.velocity.length() / 10, 0.9, 1.1)
				if not $WallScrape.playing:
					$WallScrape.play()
			elif $WallScrape.playing:
				$WallScrape.stop()
			
			if Input.is_action_just_pressed("jump") and not owner.coyote_timer.is_stopped() and Globals.unlock_jump:
				$Jump.play()
		else:
			if Input.is_action_just_pressed("roll"):
				$RollStop.play()
				$GrappleStart.play()
			
			if (owner.is_on_floor() or owner.is_on_wall()) and not owner.velocity.is_zero_approx():
				$RollScrape.pitch_scale = owner.velocity.length() / 10
				if not $RollScrape.playing:
					$RollScrape.play()
			elif $RollScrape.playing:
				$RollScrape.stop()
			
			if $Walk.playing:
				$Walk.stop()
			
			if owner.state_bouncing and owner.test_move(owner.global_transform, owner.velocity * delta):
				$Bounce.play()
		
		if not owner.regrab_timer.is_stopped() and (Input.is_action_pressed("jump") or Input.is_action_pressed("boost")):
			if not $Thrust.playing:
				$Thrust.play()
		elif not owner.regrab_timer.is_stopped():
			$Thrust.stop()
		
		if Input.is_action_just_pressed("boost"):
			if owner.state_rolling and Globals.unlock_downboost:
				$Boost.play()
			elif not owner.state_rolling and Globals.unlock_lateralboost:
				$Boost.play()
		
		if Input.is_action_just_released("fire") and owner.state_rolling and Globals.unlock_spin:
			$Boost.play()
		
		if Input.is_action_just_pressed("fire") and owner.grapple_ready and Globals.unlock_grapple:
			$GrappleStart.play()
			$GrapplePull.play()
		if not owner.state_grappling and $GrapplePull.playing:
			$GrappleEnd.play()
			$GrapplePull.stop()
