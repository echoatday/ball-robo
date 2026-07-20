extends Node3D

@export var rotator := Node3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	$AnimatableBody3D.rotate_y(0.003)
