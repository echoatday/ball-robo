extends Sprite3D

@export var box_texture: Array[Texture]
@onready var collision := $button_body
@onready var selected := false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if owner.pilot_cast.get_collider() == $button_body:
		texture = box_texture[1]
		$button_text.modulate = Color(0, 0, 0)
		$button_text.outline_size = 12
		if Input.is_action_just_pressed("fire"):
			get_tree().quit()
	else:
		$button_text.modulate = Color(0.478, 0.804, 0.804)
		$button_text.outline_size = 0
		texture = box_texture[0]
