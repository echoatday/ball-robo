extends CharacterBody3D

@export var camera: Node3D
@export var camera_gimbal: Node3D
@export var cockpit: Node3D
@export var collider: Node3D
@export var sphere: Node3D
@export_category("UI")
@export var reticle: Node3D
@export var reticle_pilot: Node3D
@export var box_display: Node3D
@export var dead_text: Node3D
@export_category("Grappling")
@export var grapple_cable: Node3D
@export var grapple_cast: Node3D
@export var spin_cast: Node3D
@export_category("Instruments")
@export var pilot_rig: Node3D
@export var seat: Node3D
@export var cockpit_light: Light3D

const SPEED = 10
const ACCEL = 1.1
const BOOST_SPEED = 8
const JUMP_VELOCITY = 6
const LOOK_SPEED = 0.0002
const MARGIN = 160
const GRAPPLE_SPEED = 20
const GRAPPLE_LIMIT = 0.85

var state_looking := false
var state_rolling := false
var state_grappling := false
var state_spinning := false
var state_sticking := false
var state_dead := false
var can_boost := true
var can_jump := true
var can_grapple := true
var can_spin := true
var current_speed = SPEED
var current_accel = ACCEL
var spin_velocity := Vector3.ZERO
var spin_speed = 0

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

var spin_strength = energy_cost.large/6

var grapple_hook_position := Vector3.ZERO
var grapple_ready := false

func _ready() -> void:
	Globals.player = self

func _physics_process(delta: float) -> void:
	transform = transform.orthonormalized()
	
	# Add the gravity.
	if not state_sticking and not is_on_floor():
		velocity += get_gravity() * delta
	elif state_sticking:
		velocity += -get_gravity() * delta
		velocity.y = clamp(velocity.y, -current_speed*2, current_speed/2)
		energy_checkout += energy_recharge+2

	# Get the input direction and handle the movement/deceleration.
	var input_dir: Vector2
	if state_looking and not state_dead:
		input_dir = Input.get_vector("left", "right", "forward", "back")
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
	
	if not direction.x and is_on_floor():
		velocity.x = move_toward(velocity.x, 0, current_accel)
	if not direction.z and is_on_floor():
		velocity.z = move_toward(velocity.z, 0, current_accel)
	
	# --- ROLLING ---
	if state_rolling:
		state_grappling = false
		collider.shape.radius = 0.4
		current_speed = SPEED * 1.5
		current_accel = ACCEL / 4
	else:
		state_spinning = false
		collider.shape.radius = 0.9
		current_speed = SPEED
		current_accel = ACCEL
	
	# --- SPINNING ---
	var spin_direction = (spin_cast.global_position - global_position).normalized()
	if state_spinning:
		current_speed = SPEED * 0.5
		spin_speed = move_toward(spin_speed, spin_strength, 0.2)
		spin_velocity = spin_direction*spin_speed
	else:
		spin_speed = 0
		spin_velocity = Vector3.ZERO
	
	
	# --- GRAPPLING ---
	
	# Hold grapple
	var grapple_direction = (grapple_hook_position - position).normalized()
	var grapple_idle_direction = (spin_cast.global_position - position).normalized()
	var cable_material = grapple_cable.get_child(0).material
	if Input.is_action_pressed("fire") and state_grappling:
		var grapple_velocity = ((grapple_hook_position - position) - grapple_direction) * 2
		velocity = velocity.move_toward(grapple_velocity, current_accel*1.5)
		if grapple_velocity.length() < SPEED:
			state_grappling = false
		else:
			cable_material.set_albedo(Color(0.8-(grapple_velocity.length()/30),0.2,0.2))
	else:
		state_grappling = false

	if not state_grappling and grapple_cast.is_colliding():
		grapple_ready = true
		can_grapple = true
	elif not grapple_cast.is_colliding():
		grapple_ready = false
	else:
		grapple_ready = true
		can_grapple = true
	
	# Grapple cable
	if state_grappling:
		grapple_cable.visible = true
		grapple_cable.look_at(grapple_hook_position)
		grapple_cable.scale.z = (grapple_hook_position - grapple_cable.transform.origin).length()*2
	else:
		grapple_cable.visible = false
	
	# Stat management
	energy -= energy_checkout
	energy_checkout = 0
	
	cockpit_light.light_color = Color(heat*0.001,0.1,0.5-(heat*0.001))
	
	if heat > max_heat:
		state_dead = true
	
	if energy < 0:
		heat += -energy*4
	elif energy < max_energy and not state_grappling and not state_spinning:
		energy += energy_recharge

	heat += heat_level
	
	heat = clamp(heat, 0, max_heat+111)
	energy = clamp(energy, 0, max_energy)
	
	# --- ACTIONS ---
	if state_spinning:
		can_jump = false
		can_boost = false
	elif is_on_floor() or state_grappling:
		can_boost = true
		can_jump = true
		can_spin = true
	elif is_on_wall() and state_sticking:
		can_jump = true
	elif is_on_wall() and not state_rolling:
		can_jump = true
	else:
		can_jump = false
	
	if state_dead:
		heat = 0
		energy = 0
		velocity = Vector3.ZERO
		state_looking = false
		can_jump = false
		can_boost = false
		can_spin = false
		can_grapple = false
		dead_text.visible = true
		
	
	if Input.is_action_just_pressed("jump") and can_jump:
		energy_checkout += energy_cost.small
		velocity.y = JUMP_VELOCITY
		if not is_on_floor():
			velocity.x += get_wall_normal().x * BOOST_SPEED*1.6
			velocity.z += get_wall_normal().z * BOOST_SPEED*1.6
			state_grappling = false
		can_jump = false
		
	if Input.is_action_just_pressed("roll"):
		if is_on_floor() or state_grappling:
			velocity.y = JUMP_VELOCITY/3
			state_grappling = false
		state_rolling = not state_rolling
		
	if not state_rolling:
		state_sticking = false
		
		if Input.is_action_just_pressed("boost") and input_dir != Vector2.ZERO and can_boost:
			velocity.y = JUMP_VELOCITY/3
			velocity += direction * BOOST_SPEED
			energy_checkout += energy_cost.large
			can_boost = false
			state_grappling = false
		
		if Input.is_action_just_pressed("fire") and grapple_ready:
			grapple_hook_position = grapple_cast.get_collider(0).global_position
			energy_checkout += energy_cost.small
			state_grappling = true
	else:
		if Input.is_action_pressed("boost") and is_on_wall():
			state_sticking = true
		else:
			state_sticking = false
		
		if Input.is_action_just_pressed("fire") and can_spin:
			state_spinning = true
		if Input.is_action_just_released("fire") and can_spin:
			energy_checkout += spin_velocity.length()*4
			velocity = spin_velocity
			state_spinning = false
			can_spin = false
			can_boost = true

	aim()
	move_and_slide()

# Aiming system
func aim() -> void:
	
	var cursor_location = get_viewport().get_mouse_position()
	var screen_center_hori = get_viewport().size.x/2
	var screen_center_verti = get_viewport().size.y/2
	
	var ui_edge_x = get_viewport().size.x/3.7
	var ui_edge_y = get_viewport().size.y/5
	
	if state_looking:
		reticle_pilot.visible = false
		camera.rotation = Vector3.ZERO
		camera_gimbal.rotation = Vector3.ZERO
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		cursor_location.x = clamp(cursor_location.x, screen_center_hori-ui_edge_x, screen_center_hori+ui_edge_x)
		cursor_location.y = clamp(cursor_location.y, screen_center_verti-ui_edge_y, screen_center_verti+ui_edge_y)
		pilot_rig.look_at(camera.project_position((cursor_location/9)+Vector2(get_viewport().size/2.25),10))
		#reticle handling
		reticle.global_position = camera.project_position(cursor_location,0.2)
		reticle.look_at(camera.global_position)
		reticle.rotation.z = 0
	else:
		reticle_pilot.visible = true
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	
	# Mouse turning control
	if Input.is_action_just_pressed("look") and not state_dead:
		state_looking = not state_looking
	if state_looking and not state_grappling:
		var cursor_distance_from_center_x = screen_center_hori - cursor_location.x
		var cursor_distance_from_center_y = screen_center_verti - cursor_location.y
		rotate_y(cursor_distance_from_center_x * LOOK_SPEED)
		seat.rotate_x(cursor_distance_from_center_y * LOOK_SPEED)
		
		seat.rotation.x = clamp(seat.rotation.x, -0.9, 0.9)

func _unhandled_input(event):
	if not state_looking and event is InputEventMouseMotion:
		camera_gimbal.rotate_y(-event.relative.x * 0.002)
		camera.rotate_x(-event.relative.y * 0.002)
