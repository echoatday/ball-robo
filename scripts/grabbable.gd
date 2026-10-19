extends Node3D

@export_enum("nothing", "cube", "brain") var pickup_type: int
@export_enum("cube_rm", "cube_cd", "brain_home") var pickup_location: int

@export var raycast: RayCast3D
@export var looker: Node3D
@export var targeting_box: Node3D
@export var collider: Node3D

var target_visible := false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	pickup_type = Globals.item_locations[pickup_location]
	match pickup_type:
		0:
			$FuncGodotMap.visible = false
			$FuncGodotMap2.visible = false
		1:
			$FuncGodotMap.visible = false
			$FuncGodotMap.visible = true
		2:
			$FuncGodotMap.visible = true
			$FuncGodotMap2.visible = false
	
	looker.look_at(Globals.player.global_position)
	var distance_to_player = global_position.distance_to(Globals.player.global_position)
	
	if raycast.is_colliding() and raycast.get_collider() == Globals.player:
		targeting_box.position.z = -distance_to_player + 0.11
		targeting_box.position.y = -Globals.player.reticle.position.y/randi_range(16,22)
		targeting_box.position.x = Globals.player.reticle.position.x/randi_range(14,22)
		if distance_to_player <= 36.2 and Globals.unlock_grapple:
			targeting_box.rotation_degrees.z = 0
		else:
			targeting_box.rotation_degrees.z = 45
		target_visible = true
	else:
		targeting_box.position = Vector3.ZERO
		target_visible = false
	
	
