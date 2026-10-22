extends Node3D

@export var collision: StaticBody3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if Globals.self_destruct:
		collision.set_collision_layer_value(1,true)
		visible = true
