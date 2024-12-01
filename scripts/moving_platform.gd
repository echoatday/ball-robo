extends Path3D

@export var speed = 2.0
@export var start_pos = 0

@onready var path = $PathFollow3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	path.progress = start_pos


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if Globals.switch1:
		path.progress += speed * delta
