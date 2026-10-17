extends Path3D

@export var speed = 4.0
@export var start_pos = 0

@export var ui_text: Node3D
@export var ui_all: Node3D
@export var raycast: RayCast3D

@onready var path = $PathFollow3D

var opening := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	path.progress_ratio = start_pos


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if opening and path.progress_ratio < 0.90:
		if $Outside1.position.z > -1.5:
			$Outside1.position.z -= 0.1
		if $Outside2.position.z < 1.5:
			$Outside2.position.z += 0.1
		if $Timer.is_stopped():
			path.progress += speed * delta
	elif not opening and path.progress_ratio > 0.02:
		path.progress -= speed * delta
	elif not opening:
		if $Outside1.position.z < -1:
			$Outside1.position.z += 0.1
		if $Outside2.position.z > 1:
			$Outside2.position.z -= 0.1
		path.progress_ratio = start_pos
	
	ui_all.look_at(Globals.player.global_position)
	var distance_to_player = ui_all.global_position.distance_to(Globals.player.global_position)
	if raycast.is_colliding() and raycast.get_collider() == Globals.player:
		ui_text.position.z = -distance_to_player + 0.11
		ui_text.position.y = -Globals.player.reticle.position.y/randi_range(24,26)
		ui_text.position.x = Globals.player.reticle.position.x/randi_range(26,28)
	else:
		ui_text.position = Vector3.ZERO
	
	if opening:
		ui_text.text = "⚬"
	elif Globals.unlock_door:
		ui_text.text = "○"
	else:
		ui_text.text = "×"


func _on_area_3d_body_entered(body: Node3D) -> void:
	if Globals.unlock_vault:
		$Timer.start()
		opening = true


func _on_area_3d_body_exited(body: Node3D) -> void:
		opening = false
