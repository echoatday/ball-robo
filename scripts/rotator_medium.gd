extends Node3D

@export var speed := 6

func _ready() -> void:
	$SFX.pitch_scale = clampf(0.9 + (speed * 0.01), 1.0, 1.5)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	$AnimatableBody3D.rotate_y(speed * 0.001)
 
