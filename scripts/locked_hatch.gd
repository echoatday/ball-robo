extends Node3D

@export var speed = 4.0
@export var start_pos = 0

@onready var path1 = $Hatch1/PathFollow3D
@onready var path2 = $Hatch2/PathFollow3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	path1.progress_ratio = start_pos
	path2.progress_ratio = start_pos


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if path1.progress_ratio < 1 and Globals.doors_blastfurnace:
		path1.progress += speed * delta
	if path2.progress_ratio < 1 and Globals.doors_blastfurnace:
		path2.progress += speed * delta
