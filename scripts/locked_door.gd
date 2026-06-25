extends Path3D

@export var speed = 4.0
@export var start_pos = 0

@onready var path = $PathFollow3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	path.progress_ratio = start_pos


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if path.progress_ratio < 0.96 and Globals.doors_rawmaterials:
		path.progress += speed * delta
