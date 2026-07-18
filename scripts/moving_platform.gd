extends Path3D

@export var speed = 4.0
@export var start_pos = 0.0

@onready var path = $PathFollow3D

var pushing := true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	path.progress_ratio = start_pos
	if start_pos == 1.0:
		pushing = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if $Timer.is_stopped():
		if path.progress_ratio < 1.0 and pushing == true:
			path.progress += speed * delta
		elif path.progress_ratio > 0.0 and pushing == false:
			path.progress -= speed * delta
		else:
			pushing = not pushing
			$Timer.start()
