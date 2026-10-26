extends Sprite3D

@export var box_texture: Array[Texture]
@onready var collision := $button_body
@onready var selected := false

@export_enum("default_game","random_game","save","load","quit") var button_type: int


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if owner.pilot_cast.get_collider() == $button_body:
		texture = box_texture[1]
		$button_text.modulate = Color(0, 0, 0)
		$button_text.outline_size = 12
		if Input.is_action_just_pressed("fire"):
			match(button_type):
				0:
					var default_file = FileAccess.open("res://saves/newgame.json", FileAccess.READ)
					var json = JSON.new()
					var parse_result = default_file.get_as_text()
					var save_file = FileAccess.open("res://saves/savegame.json", FileAccess.WRITE)
					save_file.store_line(parse_result)
					owner.state_dead = true
				1:
					# this is not real yet
					owner.state_dead = true
				2:
					get_parent().get_node("memory_border").save_to_slot()
				3:
					get_parent().get_node("memory_border").load_from_slot()
					owner.state_dead = true
				4:
					get_tree().quit()
	else:
		$button_text.modulate = Color(0.478, 0.804, 0.804)
		$button_text.outline_size = 0
		texture = box_texture[0]
