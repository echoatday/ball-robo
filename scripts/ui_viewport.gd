extends SubViewport

@onready var box_reticle = $box_sprite

func _process(delta: float) -> void:
	#size.y = get_window().size.y
	#size.x = size.y*2
	#size.x = size.x * 2
	box_reticle.position = get_mouse_position()
	print_debug(Vector2(size / get_window().size))
	pass
