extends Sprite3D

@export_enum("game","memory","options","quit") var this_menu: int
@onready var selected := false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if owner.pilot_cast.get_collider() == $button_body:
		self.visible = false
		if Input.is_action_just_pressed("fire"):
			get_parent().current_menu = this_menu
