extends Node3D

var start_rotation: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_rotation = rotation_degrees.y
	if Globals.pipenetwork_state:
		rotation_degrees.y = 90 + start_rotation
	else:
		rotation_degrees.y = 0 + start_rotation


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if Globals.pipenetwork_state and rotation_degrees.y < 90 + start_rotation:
		rotation_degrees.y += 1
	elif not Globals.pipenetwork_state and rotation_degrees.y > 0 + start_rotation:
		rotation_degrees.y -= 1
