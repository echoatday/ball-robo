extends Node3D

@export var speed := 6


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	$AnimatableBody3D.rotate_y(speed * 0.001)
