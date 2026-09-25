extends Node3D

@onready var sky_mesh = $FuncGodotMap/entity_0_worldspawn/entity_0_mesh_instance
@onready var old_position = Globals.player.camera.global_position
@onready var old_rotation = Globals.player.camera.global_rotation_degrees

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var new_position = Globals.player.camera.global_position
	var pos_difference = old_position - new_position
	var new_rotation = Globals.player.camera.global_rotation_degrees
	var rot_difference = old_rotation - new_rotation
	
	sky_mesh.get_active_material(9).uv1_offset += Vector3(pos_difference.z,pos_difference.x,pos_difference.y) * -0.1
	
	old_position = new_position
	old_rotation = new_rotation
