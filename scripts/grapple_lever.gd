extends Node3D

@export var raycast: RayCast3D
@export var looker: Node3D
@export var targeting_box: Node3D
@export var lever: Node3D
@export var collider: Node3D

var target_visible := false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	looker.look_at(Globals.player.global_position)
	var distance_to_player = global_position.distance_to(Globals.player.global_position)
	
	if Globals.pipenetwork_state:
		lever.rotation_degrees.x = 135
	else:
		lever.rotation_degrees.x = 45
	
	if raycast.is_colliding() and raycast.get_collider() == Globals.player:
		targeting_box.position.z = -distance_to_player + 0.11
		targeting_box.position.y = -Globals.player.reticle.position.y/randi_range(16,22)
		targeting_box.position.x = Globals.player.reticle.position.x/randi_range(14,22)
		if Globals.unlock_grapple:
			targeting_box.rotation_degrees.z = 0
		else:
			targeting_box.rotation_degrees.z = 45
		target_visible = true
	else:
		targeting_box.position = Vector3.ZERO
		target_visible = false
