extends Node3D


func _on_visibility_changed() -> void:
	if visible:
		for child in get_children():
			if "collision" in child:
				child.collision.set_collision_layer_value(4,true)
	else:
		for child in get_children():
			if "collision" in child:
				child.collision.set_collision_layer_value(4,false)
