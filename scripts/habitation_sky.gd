extends Node3D

@onready var sky_mesh = $FuncGodotMap/entity_0_worldspawn/entity_0_mesh_instance
@onready var old_position = Globals.player.camera.global_position
@onready var old_rotation = Globals.player.camera.global_rotation_degrees
@onready var base_color = Color(1.7,1.9,1.9)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var new_position = Globals.player.camera.global_position
	var pos_difference = old_position - new_position
	var new_rotation = Globals.player.camera.global_rotation_degrees
	var rot_difference = old_rotation - new_rotation
	
	if Engine.get_frames_drawn() % ceili(Engine.get_frames_per_second()/2) == 0:
		sky_mesh.get_active_material(7).uv1_offset += Vector3(0.002,0,0.002)
		sky_mesh.get_active_material(7).uv1_offset += Vector3(pos_difference.x + pos_difference.z,pos_difference.y,pos_difference.x + pos_difference.z) * -0.1
		sky_mesh.get_active_material(7).uv1_offset += Vector3(rot_difference.y,-rot_difference.x,rot_difference.y) / 360
	
	old_position = new_position
	old_rotation = new_rotation
	
	if Engine.get_frames_drawn() % ceili(Engine.get_frames_per_second()/randi_range(1,4)) == 0:
		sky_mesh.get_active_material(7).albedo_color = base_color * randf_range(0.95,1.0)
