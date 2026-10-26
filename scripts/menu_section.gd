extends Node3D


func _on_visibility_changed() -> void:
	if visible:
		for child in get_children():
			if child.collision:
				child.collision.set_collision_layer_value(4,true)
	else:
		for child in get_children():
			if child.collision:
				child.collision.set_collision_layer_value(4,false)
