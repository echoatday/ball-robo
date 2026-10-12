extends Path3D

@export var speed = 4.0
@export var start_pos = 0

@onready var path = $PathFollow3D

var opening := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	path.progress_ratio = start_pos


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if opening and path.progress_ratio < 0.95:
		path.progress += speed * delta
	elif not opening and path.progress_ratio > 0.05:
		path.progress -= speed * delta
	elif not opening:
		path.progress_ratio = start_pos
		


func _on_area_3d_body_entered(body: Node3D) -> void:
	if Globals.unlock_door:
		opening = true


func _on_area_3d_body_exited(body: Node3D) -> void:
	opening = false
