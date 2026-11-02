extends Sprite3D

@export var box_texture: Array[Texture]
@export var email_border: Node3D
@onready var collision := $button_body
@onready var selected := false
@export var email_subject: String
@export_multiline var email_text: String


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if email_subject.length() > 12:
		$button_text.text = email_subject.erase(10,100) + ".."
	else:
		$button_text.text = email_subject
	# pip if email is selected
	if email_border.selected_email == int(name.split("_")[1]):
		$selection_pip.visible = true
	else:
		$selection_pip.visible = false
	
	if owner.pilot_cast.get_collider() == $button_body:
		texture = box_texture[1]
		$button_text.modulate = Color(0, 0, 0)
		$button_text.outline_size = 12
		if Input.is_action_just_pressed("fire"):
			email_border.selected_email = int(name.split("_")[1])
	else:
		$button_text.modulate = Color(0.478, 0.804, 0.804)
		$button_text.outline_size = 0
		texture = box_texture[0]
