extends Node3D

@export var ring: Node3D
@export var array: Node3D

var hover_collider = null
var looking_check := false
var bouncing_check := false
var light_start := false
var held_item := Globals.holding_item

func _process(delta: float) -> void:
	if held_item != Globals.holding_item:
		match Globals.holding_item:
			1:
				$GrabCube.play()
				$ToonMachine3.play()
			2:
				$GrabBrain.play()
				$ToonMachine3.play()
		held_item = Globals.holding_item
	
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
			$WalkInsideTurn.stop()
		
		
		if owner.state_looking:
			var look_speed = Vector2(owner.reticle.position.x*100,owner.reticle.position.y*100)
			if look_speed.length() > 2:
				$ToonMove.pitch_scale = look_speed.length() / 20
				if not $ToonMove.playing:
					$ToonMove.play()
				if not owner.state_rolling and owner.is_on_floor() and not $WalkTurn.playing and not $Walk.playing:
					$WalkTurn.play()
					$WalkInsideTurn.play()
			else:
				if $ToonMove.playing:
					$ToonMove.stop()
				if $WalkTurn.playing:
					$WalkTurn.stop()
					$WalkInsideTurn.stop()
		elif $ToonMove.playing or $WalkTurn.playing:
			$ToonMove.stop()
			$WalkTurn.stop()
			$WalkInsideTurn.stop()
		
		if not owner.state_rolling:
			if Input.is_action_just_pressed("roll"):
				$RollStart.play()
				$GrappleEnd.play()
				$CableEnd.play()
			
			if $RollScrape.playing:
				$RollScrape.stop()
			
			if $RollScreen.playing:
				$RollScreen.stop()
			
			if owner.is_on_floor() and Input.get_vector("left", "right", "forward", "back") != Vector2.ZERO:
				if not $Walk.playing:
					$Walk.play()
					$WalkInside.play()
					$WalkTurn.stop()
					$WalkInsideTurn.stop()
			else:
				$Walk.stop()
				$WalkInside.stop()
			
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
				$CableStart.play()
			
			if bouncing_check != owner.state_bouncing:
				if bouncing_check:
					$BounceInside.pitch_scale = 0.75
				else:
					$BounceInside.pitch_scale = 1.0
				bouncing_check = owner.state_bouncing
				$BounceInside.play()
			
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
				$WalkInside.stop()
			
			if $WallScrape.playing:
				$WallScrape.stop()
			
			if owner.state_bouncing and owner.test_move(owner.global_transform, owner.velocity * delta):
				$Bounce.play()
		#--
		if Input.is_action_just_pressed("jump") and not owner.regrab_timer.is_stopped():
			$Thrust.play()
			$ThrustInside.play()
			$JumpInside.pitch_scale = 0.3 + (owner.velocity.length() * 0.01)
			$JumpInside.play()
		elif Input.is_action_just_pressed("boost") and not owner.regrab_timer.is_stopped():
			$Thrust.play()
			$ThrustInside.play()
			$JumpInside.pitch_scale = 0.3 + (owner.velocity.length() * 0.01)
			$JumpInside.play()
		elif not owner.regrab_timer.is_stopped() and not Input.is_action_pressed("jump") and not Input.is_action_pressed("boost"):
			$Thrust.stop()
			$ThrustInside.stop()
		
		if Input.is_action_just_pressed("boost"):
			if owner.state_rolling and Globals.unlock_downboost:
				$Boost.play()
			elif not owner.state_rolling and Globals.unlock_lateralboost:
				$Boost.play()
		
		if Input.is_action_just_released("fire") and owner.state_rolling and Globals.unlock_spin:
			$Boost.play()
		
		if owner.state_grappling:
			$Cable.pitch_scale = 0.75 + owner.velocity.length() / 50
			$GrapplePull.pitch_scale = 0.75 + owner.velocity.length() / 50
			if not $Cable.playing:
				$GrappleStart.play()
				$CableStart.play()
				$GrapplePull.play()
				$Cable.play()
		else:
			if $GrapplePull.playing:
				$GrappleEnd.play()
				$GrapplePull.stop()
			if $Cable.playing:
				$CableEnd.play()
				$Cable.stop()
	else:
		if $RingMove.playing:
			$RingMove.stop()
