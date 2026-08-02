extends Node3D

@export var shake_timer: Timer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position = position.move_toward(-owner.velocity.normalized() * owner.basis * 0.001, 0.0001)
	if Input.is_action_just_pressed("jump") or Input.is_action_just_pressed("boost") or Input.is_action_just_pressed("roll") or Input.is_action_just_pressed("fire") or Input.is_action_just_released("fire"):
		shake_timer.start()
	
	if not shake_timer.is_stopped():
		position = position + Vector3(randf_range(-0.0004,0.0004),randf_range(-0.0004,0.0004),randf_range(-0.0004,0.0004))
