extends Node

# self.global_rotation_degrees.y
# global_position
var spawn_position
@onready var spawn_room = 0
@onready var door_rotation = self.global_rotation_degrees.y

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	pass
