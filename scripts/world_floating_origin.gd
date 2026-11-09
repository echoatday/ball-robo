extends Node3D

@export var threshold := 100

@onready var player := $Player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if (player.global_transform.origin.length() > threshold):
		float_origin()

func float_origin() -> void:
	var origin_shift = player.global_transform.origin
	get_tree().paused = true
	for child in get_children():
		child.global_transform.origin -= origin_shift
		print(player.global_transform.origin)
	get_tree().paused = false
