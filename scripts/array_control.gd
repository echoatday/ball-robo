extends MeshInstance3D

@export var lights: Array[Sprite3D]
@export var bright_lights: Array[Sprite3D]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# glow = can move, glow_bright = pressing button
	# light2,4,6,8 = movement
	# light5 = roll
	# light1 = spindash
	# light3 = grapple
	# light7 = downdash
	# light9 = latdash
	# light10,11,12 = jump,bounce,walljump
	# light13 = temp shielding
	# light14 = swim
	# light15 = energy upgrade
	
	# sorry about this...
	
	if owner.state_dead:
		for l in lights:
			l.visible = false
		for b in bright_lights:
			b.visible = false
	else:
		# movement lights
		if owner.disable_movement_timer.is_stopped():
			lights[1].visible = true
			lights[3].visible = true
			lights[5].visible = true
			lights[7].visible = true
		else:
			lights[1].visible = false
			lights[3].visible = false
			lights[5].visible = false
			lights[7].visible = false
		# roll light
		if Globals.unlock_roll:
			lights[4].visible = true
		else:
			lights[4].visible = false
		# jump and walljump lights
		if not owner.regrab_timer.is_stopped(): 
			pass
		elif Globals.unlock_jump and not owner.coyote_timer.is_stopped() and not owner.state_rolling:
			if not owner.is_on_floor():
				lights[9].visible = false
				lights[11].visible = true
			else:
				lights[11].visible = false
				lights[9].visible = true
		else:
			lights[11].visible = false
			lights[9].visible = false
		# bounce lights
		if Globals.unlock_bounce and owner.state_rolling and not owner.is_on_floor(): 
			lights[10].visible = true
		else:
			lights[10].visible = false
		# boost lights
		if not owner.regrab_timer.is_stopped(): 
			pass
		elif Globals.unlock_downboost and owner.state_rolling and owner.can_boost:
			lights[8].visible = true
			lights[6].visible = false
		elif Globals.unlock_downboost and not owner.state_rolling and owner.can_boost:
			lights[6].visible = true
			lights[8].visible = false
		else:
			lights[6].visible = false
			lights[8].visible = false
		# grapple lights
		if Globals.unlock_grapple and owner.grapple_ready and not owner.state_rolling:
			lights[2].visible = true
		else:
			lights[2].visible = false
		# spindash lights
		if Globals.unlock_spin and owner.can_spin and owner.state_rolling:
			lights[0].visible = true
		else:
			lights[0].visible = false
		# passive lights
		if Globals.unlock_heat and owner.heat_level > 0:
			lights[12].visible = true
		else:
			lights[12].visible = false
		if Globals.unlock_waterproofing and owner.state_underwater:
			lights[13].visible = true
		else:
			lights[13].visible = false
		if Globals.unlock_energy_1 and owner.energy > 300:
			lights[14].visible = true
		else:
			lights[14].visible = false
		
			
	if Input.is_action_just_pressed("forward"):
		bright_lights[1].visible = true
	if Input.is_action_just_pressed("left"):
		bright_lights[3].visible = true
	if Input.is_action_just_pressed("right"):
		bright_lights[5].visible = true
	if Input.is_action_just_pressed("back"):
		bright_lights[7].visible = true
	if Input.is_action_just_pressed("roll"):
		bright_lights[4].visible = true
	if not owner.state_rolling:
		if Input.is_action_just_pressed("jump"):
			if owner.disable_movement_timer.is_stopped():
				bright_lights[9].visible = true
			else: 
				bright_lights[11].visible = true
		if Input.is_action_just_pressed("boost"):
			bright_lights[6].visible = true
		if Input.is_action_just_pressed("fire") and owner.state_looking:
			bright_lights[2].visible = true
	else:
		if Input.is_action_just_pressed("jump"):
			bright_lights[10].visible = true
		if Input.is_action_just_pressed("boost"):
			bright_lights[8].visible = true
		if Input.is_action_just_pressed("fire") and owner.state_looking:
			bright_lights[0].visible = true
	
	if Input.is_action_just_released("forward"):
		bright_lights[1].visible = false
	if Input.is_action_just_released("left"):
		bright_lights[3].visible = false
	if Input.is_action_just_released("right"):
		bright_lights[5].visible = false
	if Input.is_action_just_released("back"):
		bright_lights[7].visible = false
	if Input.is_action_just_released("roll"):
		bright_lights[4].visible = false
	if Input.is_action_just_released("jump"):
		bright_lights[9].visible = false
		bright_lights[11].visible = false
		bright_lights[10].visible = false
	if Input.is_action_just_released("boost"):
		bright_lights[6].visible = false
		bright_lights[8].visible = false
	if Input.is_action_just_released("fire"):
		bright_lights[2].visible = false
		bright_lights[0].visible = false
