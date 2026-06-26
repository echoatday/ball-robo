extends Node3D

@export var liquid_mesh: Node3D
@export var overlay_mesh: Node3D

var bob_count := 0
var underwater := false
var player: Node3D
@onready var max_height := liquid_mesh.global_position.y-0.2

func _ready() -> void:
	overlay_mesh.scale = Vector3(1/scale.x,1/scale.y,1/scale.z)
	overlay_mesh.position.y = -0.4/scale.y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	bob_count += 1
	liquid_mesh.get_active_material(0).uv1_offset = Vector3(sin(bob_count * 0.004)*0.3, 0, sin(bob_count * 0.008)*0.1)
	if underwater:
		overlay_mesh.global_position.x = player.global_position.x
		overlay_mesh.global_position.z = player.global_position.z
		overlay_mesh.global_position.y = clamp(player.global_position.y, player.global_position.y, max_height)
		if player.state_rolling:
			max_height = liquid_mesh.global_position.y-0.1
			overlay_mesh.mesh.height = 0.199
			overlay_mesh.get_active_material(0).distance_fade_min_distance = 0.09
			overlay_mesh.get_active_material(0).distance_fade_max_distance = 0.095
			liquid_mesh.get_active_material(0).distance_fade_min_distance = 0.09
			liquid_mesh.get_active_material(0).distance_fade_max_distance = 0.095
		else:
			max_height = liquid_mesh.global_position.y-0.2
			overlay_mesh.mesh.height = 0.399
			overlay_mesh.get_active_material(0).distance_fade_min_distance = 0.19
			overlay_mesh.get_active_material(0).distance_fade_max_distance = 0.195
			liquid_mesh.get_active_material(0).distance_fade_min_distance = 0.19
			liquid_mesh.get_active_material(0).distance_fade_max_distance = 0.195

func _on_damage_zone_body_entered(body: Node3D) -> void:
	#body.heat_level += 1
	player = body
	underwater = true


func _on_damage_zone_body_exited(body: Node3D) -> void:
	#body.heat_level -= 1
	underwater = false
