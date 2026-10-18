extends Path3D

@export var speed = 4.0
@export var start_pos = 0

@export var ui_text: Node3D
@export var ui_all: Node3D
@export var raycast: RayCast3D
@export var ui_x_position := 6.0
@export var ui_y_position := 4.0

@onready var path = $PathFollow3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	path.progress_ratio = start_pos
	ui_all.position.x = ui_x_position
	ui_all.position.y = ui_y_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if path.progress_ratio < 0.96 and Globals.unlock_sheet:
		path.progress += speed * delta
	
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
