extends Node3D

@export var wind_area_collision: Node3D
@export var fan_blades: Node3D
@export var timer: Timer
@export var timer_length := 4.0
@export var constant := false
@export var wind_speed := 3

var active := true
var lifted := false

func _ready() -> void:
	if not constant:
		timer.start(timer_length)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if active:
		wind_area_collision.set_disabled(false)
		fan_blades.rotate_y(0.2)
	else:
		if timer.get_time_left() > timer_length - 0.5 or timer.get_time_left() < 0.5:
			fan_blades.rotate_y(0.1)
		wind_area_collision.set_disabled(true)
	
	if lifted:
		Globals.player.state_floating = true
		Globals.player.velocity += basis.y * (wind_speed*0.1)
		Globals.player.velocity.y += 0.123


func _on_wind_area_body_entered(body: Node3D) -> void:
	lifted = true

func _on_wind_area_body_exited(body: Node3D) -> void:
	Globals.player.state_floating = false
	lifted = false


func _on_timer_timeout() -> void:
	active = not active
