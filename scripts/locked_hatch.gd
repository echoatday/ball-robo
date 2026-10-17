extends Node3D

@export var speed = 4.0
@export var start_pos = 0

@export var ui_text: Node3D
@export var ui_all: Node3D
@export var raycast: RayCast3D

@onready var path1 = $Hatch1/PathFollow3D
@onready var path2 = $Hatch2/PathFollow3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	path1.progress_ratio = start_pos
	path2.progress_ratio = start_pos


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if path1.progress_ratio < 1 and Globals.unlock_hatch:
		path1.progress += speed * delta
	if path2.progress_ratio < 1 and Globals.unlock_hatch:
		path2.progress += speed * delta
	
	ui_all.look_at(Globals.player.global_position)
	var distance_to_player = ui_all.global_position.distance_to(Globals.player.global_position)
	if raycast.is_colliding() and raycast.get_collider() == Globals.player:
		ui_text.position.z = -distance_to_player + 0.11
		ui_text.position.y = -Globals.player.reticle.position.y/randi_range(24,26)
		ui_text.position.x = Globals.player.reticle.position.x/randi_range(26,28)
	else:
		ui_text.position = Vector3.ZERO
	
	if Globals.unlock_door:
		ui_text.text = "⚬"
	else:
		ui_text.text = "×"
