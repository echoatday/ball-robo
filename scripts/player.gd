extends CharacterBody3D

@export var camera: Node3D
@export var cockpit: Node3D
@export var collider: Node3D
@export var sphere: Node3D
@export var walk_sphere: Node3D
@export var ball_sphere: Node3D
@export_category("UI")
@export var reticle: Node3D
@export var box_display: Node3D
@export var box_texture: Array[Texture]
@export_category("Grappling")
@export var grapple_cable: Node3D
@export var grapple_cast: Node3D
@export_category("Instruments")
@export var pilot_rig: Node3D
@export var seat: Node3D
@export var cockpit_light: Light3D

const SPEED = 6.6
const ACCEL = 1.1
const BOOST_SPEED = 8
const JUMP_VELOCITY = 6
const LOOK_SPEED = 0.0002
const MARGIN = 160
const GRAPPLE_SPEED = 0.7
const GRAPPLE_LIMIT = 0.85

var state_looking := false
var state_rolling := false
var state_grappling := false
var state_spinning := false
var can_boost := true
var can_jump := true
var current_speed = SPEED
var current_accel = ACCEL
var spin_velocity := Vector3.ZERO

var max_energy := 300
var energy := 0
var energy_recharge := 1
var max_heat := 1000
var heat := 0
var heat_level := -1 # range should be -1 to 1. -1 is fine, 0 is hot, 1 is dangerous

var energy_cost := {
	"small": 50,
	"large": 100,
}
var energy_checkout := 0

var grapple_hook_position := Vector3.ZERO
var grapple_ready := false

func _physics_process(delta: float) -> void:
	transform = transform.orthonormalized()
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("left", "right", "forward", "back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if abs(velocity.x) < abs(direction.x) * current_speed:
		velocity.x += direction.x * current_accel
	elif is_on_floor():
		velocity.x = move_toward(velocity.x, direction.x * current_speed, current_accel)
	else:
		velocity.x = move_toward(velocity.x, direction.x * current_speed, ACCEL/10)
	if abs(velocity.z) < abs(direction.z) * current_speed:
		velocity.z += direction.z * current_accel
	elif is_on_floor():
		velocity.z = move_toward(velocity.z, direction.z * current_speed, current_accel)
	else:
		velocity.z = move_toward(velocity.z, direction.z * current_speed, ACCEL/10)
	
	if !direction.x and is_on_floor():
		velocity.x = move_toward(velocity.x, 0, current_accel)
	if !direction.z and is_on_floor():
		velocity.z = move_toward(velocity.z, 0, current_accel)
	
	# --- SPINNING ---
	if state_spinning:
		velocity.x = move_toward(velocity.x, 0, ACCEL)
		velocity.z = move_toward(velocity.z, 0, ACCEL)
		ball_sphere.global_rotate(Vector3(spin_velocity.z, 0, -spin_velocity.x).normalized(), 0.01*spin_velocity.length())
		spin_velocity.x = move_toward(spin_velocity.x,direction.x*(energy_cost.large/4),1)
		spin_velocity.z = move_toward(spin_velocity.z,direction.z*(energy_cost.large/4),1)
	else:
		spin_velocity = Vector3.ZERO
	
	
	# --- GRAPPLING ---
	
	# Grapple UI display
	var grapple_cast_hit = grapple_cast.get_collider(0)
	if !grapple_ready and !state_grappling:
		box_display.set_modulate(Color(0.4,1,0.4))
		box_display.texture = box_texture[1]
	elif !state_grappling:
		box_display.set_modulate(Color(1,1,0.4))
		box_display.texture = box_texture[2]
	else:
		box_display.set_modulate(Color(1,0.2,0.2))
		box_display.texture = box_texture[3]
	
	# Hold grapple
	var grapple_direction = (grapple_hook_position - position).normalized()
	var grapple_idle_direction = (grapple_cast.get_collision_point(0) - position).normalized()
	if Input.is_action_pressed("grapple") and state_grappling:
		var grapple_target_speed = grapple_direction * GRAPPLE_SPEED
		velocity += grapple_target_speed
	else:
		state_grappling = false
	
	# Break cable if the angle is too sharp
	var cable_material = grapple_cable.get_child(0).material
	if abs(grapple_direction.x + cockpit.global_transform.basis.z.x) > GRAPPLE_LIMIT or abs(grapple_direction.z + cockpit.global_transform.basis.z.z) > GRAPPLE_LIMIT or abs(grapple_direction.y + cockpit.global_transform.basis.x.y) > GRAPPLE_LIMIT+0.05:
		state_grappling = false
	elif abs(grapple_direction.x + cockpit.global_transform.basis.z.x) > GRAPPLE_LIMIT-0.3 or abs(grapple_direction.z + cockpit.global_transform.basis.z.z) > GRAPPLE_LIMIT-0.3 or abs(grapple_direction.y + cockpit.global_transform.basis.x.y) > GRAPPLE_LIMIT+0.05-0.2:
		cable_material.set_albedo(Color(0.6,0.2,0.2))
	else:
		cable_material.set_albedo(Color(0.2,0.2,0.2))

	if !state_grappling and grapple_cast_hit:
		if abs(grapple_idle_direction.x + cockpit.global_transform.basis.z.x) > GRAPPLE_LIMIT or abs(grapple_idle_direction.z + cockpit.global_transform.basis.z.z) > GRAPPLE_LIMIT or abs(grapple_idle_direction.y + cockpit.global_transform.basis.x.y) > GRAPPLE_LIMIT+0.05:
			grapple_ready = false
			box_display.set_modulate(Color(0.2,0.2,0.2))
		else:
			grapple_ready = true
	elif !grapple_cast_hit:
		grapple_ready = false
	else:
		grapple_ready = true
	
	# Grapple cable
	if state_grappling:
		grapple_cable.visible = true
		grapple_cable.look_at(grapple_hook_position)
		grapple_cable.scale.z = (grapple_hook_position - grapple_cable.transform.origin).length()*2
	else:
		grapple_cable.visible = false
	
	# --- ROLLING ---
	if state_rolling:
		state_grappling = false
		if is_on_floor():
			ball_sphere.global_rotate(Vector3(velocity.z, 0, -velocity.x).normalized(), 0.01*velocity.length())
		else:
			ball_sphere.global_rotate(Vector3(velocity.z, 0, -velocity.x).normalized(), 0.005*velocity.length())
		box_display.texture = box_texture[0]
		collider.shape.radius = 0.4
		current_speed = SPEED * 2
		current_accel = ACCEL / 4
		walk_sphere.visible = false
		ball_sphere.visible = true
	else:
		state_spinning = false
		collider.shape.radius = 0.9
		current_speed = SPEED
		current_accel = ACCEL
		walk_sphere.visible = true
		ball_sphere.visible = false
	
	# Stat management
	energy -= energy_checkout
	energy_checkout = 0
	
	cockpit_light.light_color = Color(heat*0.001,0.1,0.5-(heat*0.001))
	
	if heat > max_heat:
		print_debug("YOU'RE DEAD")
	
	if energy < 0:
		heat += -energy*4
	elif energy < max_energy and !state_grappling and !state_spinning:
		energy += energy_recharge

	heat += heat_level
	
	heat = clamp(heat, 0, max_heat)
	energy = clamp(energy, 0, max_energy)
	
	# --- ACTIONS ---
	if is_on_floor() or state_grappling:
		can_boost = true
		can_jump = true
	elif is_on_wall():
		can_jump = true
	else:
		can_jump = false
		
	
	if Input.is_action_just_pressed("jump") and can_jump:
		energy_checkout += energy_cost.small
		velocity.y = JUMP_VELOCITY
		if !is_on_floor():
			velocity.x += get_wall_normal().x * BOOST_SPEED*1.7
			velocity.z += get_wall_normal().z * BOOST_SPEED*1.7
			state_grappling = false
		can_jump = false
		
	if Input.is_action_just_pressed("roll"):
		if is_on_floor() or state_grappling:
			velocity.y = JUMP_VELOCITY/3
			state_grappling = false
		ball_sphere.set_global_rotation(walk_sphere.get_global_rotation())
		state_rolling = !state_rolling
		
	if !state_rolling:
		if Input.is_action_just_pressed("boost") and input_dir != Vector2.ZERO and can_boost:
			velocity.y = JUMP_VELOCITY/3
			velocity += direction * BOOST_SPEED
			energy_checkout += energy_cost.large
			can_boost = false
			state_grappling = false
			state_rolling = false
		
		if Input.is_action_just_pressed("grapple") and grapple_ready:
			grapple_hook_position = grapple_cast.get_collision_point(0)
			energy_checkout += energy_cost.small
			state_grappling = true
	else:
		if Input.is_action_just_pressed("boost"):
			state_spinning = true
		if Input.is_action_just_released("boost"):
			energy_checkout += spin_velocity.length()*4
			velocity += spin_velocity
			state_spinning = false

	aim()
	move_and_slide()

# Aiming system
func aim() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	var cursor_location = get_viewport().get_mouse_position()
	var screen_center_hori = get_viewport().size.x/2
	var screen_center_verti = get_viewport().size.y/2
	
	# Mouse turning control
	if Input.is_action_just_pressed("look"):
		state_looking = !state_looking
	if state_looking:
		var cursor_distance_from_center_x = screen_center_hori - cursor_location.x
		var cursor_distance_from_center_y = screen_center_verti - cursor_location.y
		rotate_y(cursor_distance_from_center_x * LOOK_SPEED)
		seat.rotate_x(cursor_distance_from_center_y * LOOK_SPEED)
		
		if !state_rolling:
			seat.rotation.x = clamp(seat.rotation.x, -0.6, 0.6)
		else:
			seat.rotation.x = clamp(seat.rotation.x, -0.99, 0.99)
	
	pilot_rig.look_at(camera.project_position((cursor_location/9)+Vector2(get_viewport().size/2.26),10))
	
	# Reticle handling
	reticle.global_position = camera.project_position(cursor_location,0.2)
	reticle.look_at(camera.global_transform.origin)
