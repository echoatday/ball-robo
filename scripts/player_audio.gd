extends Node3D

@export var ring: Node3D
@export var array: Node3D

var hover_collider = null
var looking_check := false
var light_start := false

func _process(delta: float) -> void:
	if array.play_sound:
		if array.lights[array.sound_index].visible:
			$Light.play()
		else:
			$Error.play()
	
	if owner.state_looking != looking_check:
		if owner.state_looking:
			$LookStart.play()
		else:
			$LookStop.play()
		looking_check = owner.state_looking
	
	if owner.state_dead and not $DeadDrone.playing:
		$ToonMachine2.play()
		$DeadDrone.play()
		$AliveDrone.stop()
		$AliveDrone.pitch_scale = 1.0
	elif not owner.state_dead and $DeadDrone.playing:
		$ToonMachine1.play()
		$DeadDrone.stop()
		$AliveDrone.play()
	
	if $AliveDrone.playing:
		$AliveDrone.pitch_scale = 1.0 + (owner.heat * 0.001)
	
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
		if (not is_equal_approx(ring.rotation_degrees.x,90) and not is_equal_approx(ring.rotation_degrees.x,1)) or owner.state_spinning:
			if not $RingMove.playing:
				$RingMove.play()
			if not owner.spin_velocity.is_zero_approx():
				$RingMove.pitch_scale = owner.spin_velocity.length() / 8.8
			else:
				$RingMove.pitch_scale = 1.0 #+ (ring.rotation_degrees.x / 400)
		else:
			if $RingMove.playing:
				$RingMove.stop()
		
		if not owner.is_on_floor() and $WalkTurn.playing:
			$WalkTurn.stop()
		
		
		if owner.state_looking:
			var look_speed = Vector2(owner.reticle.position.x*100,owner.reticle.position.y*100)
			if look_speed.length() > 0.5:
				$ToonMove.pitch_scale = look_speed.length() / 20
				if not $ToonMove.playing:
					$ToonMove.play()
				if not owner.state_rolling and owner.is_on_floor() and not $WalkTurn.playing and not $Walk.playing:
					$WalkTurn.play()
			else:
				if $ToonMove.playing:
					$ToonMove.stop()
				if $WalkTurn.playing:
					$WalkTurn.stop()
		elif $ToonMove.playing or $WalkTurn.playing:
			$ToonMove.stop()
			$WalkTurn.stop()
		
		if not owner.state_rolling:
			if Input.is_action_just_pressed("roll"):
				$RollStart.play()
				$GrappleEnd.play()
			
			if $RollScrape.playing:
				$RollScrape.stop()
			
			if $RollScreen.playing:
				$RollScreen.stop()
			
			if owner.is_on_floor() and Input.get_vector("left", "right", "forward", "back") != Vector2.ZERO:
				if not $Walk.playing:
					$Walk.play()
					$WalkTurn.stop()
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
				
			if not owner.velocity.is_zero_approx():
				var speed_scale: int
				if owner.is_on_floor() or owner.is_on_wall():
					speed_scale = 10
				else:
					speed_scale = 15
				$RollScreen.pitch_scale = Vector3(owner.velocity.z, 0, -owner.velocity.x).length() / speed_scale
				if not $RollScreen.playing:
					$RollScreen.play()
			elif $RollScreen.playing:
				$RollScreen.stop()
			
			if $Walk.playing:
				$Walk.stop()
			
			if $WallScrape.playing:
				$WallScrape.stop()
			
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
	else:
		if $RingMove.playing:
			$RingMove.stop()
