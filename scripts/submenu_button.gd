extends Sprite3D

@export var box_texture: Array[Texture]
@onready var collision := $button_body
@onready var label := $button_text
var selected := false
var clicked := false

@export_enum("default_game","random_game","save","load","quit",
"forward","back","left","right","fire","roll","boost","jump",
"look","look_up","look_down","look_left","look_right",
"sfx_in","sfx_out","music","fps30","fps60","fps120","fps144","fps240",
"r25","r50","r67","r85","r100","r150","windowed","borderless","fullscreen") var button_type: int


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if owner.pilot_cast.get_collider() == $button_body:
		texture = box_texture[1]
		$button_text.modulate = Color(0, 0, 0)
		$button_text.outline_size = 12
		if Input.is_action_just_pressed("fire"):
			clicked = true
			match(button_type):
				0:
					var default_file = FileAccess.open("res://saves/newgame.json", FileAccess.READ)
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
					await get_tree().create_timer(0.2).timeout
					get_tree().quit()
	elif selected:
		texture = box_texture[1]
		$button_text.modulate = Color(0, 0, 0)
		$button_text.outline_size = 12
	else:
		$button_text.modulate = Color(0.478, 0.804, 0.804)
		$button_text.outline_size = 0
		texture = box_texture[0]
	
	if clicked and Input.is_action_just_released("fire"):
		clicked = false
