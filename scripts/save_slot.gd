extends Sprite3D

@export var box_texture: Array[Texture]
@onready var collision := $button_body
@onready var selected := false
@onready var current_slot := int(self.name.remove_chars("save_slot_"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$button_text.text = self.name
	# change save slot name for the pilot to comment on recent emails
	
	if get_parent().get_node("memory_border").selected_slot == current_slot:
		$selection_pip.visible = true
	else:
		$selection_pip.visible = false
	
	if owner.pilot_cast.get_collider() == $button_body:
		texture = box_texture[1]
		$button_text.modulate = Color(0, 0, 0)
		$button_text.outline_size = 12
		if Input.is_action_just_pressed("fire"):
			get_parent().get_node("memory_border").selected_slot = current_slot
	else:
		$button_text.modulate = Color(0.478, 0.804, 0.804)
		$button_text.outline_size = 0
		texture = box_texture[0]
