extends Sprite3D

@export var box_texture: Array[Texture]
@onready var grapple_cast = owner.grapple_cast

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if not owner.state_rolling:
		if not owner.can_grapple:
			set_modulate(Color(0.2,0.2,0.2))
			texture = box_texture[3]
		elif not owner.grapple_ready and not owner.state_grappling:
			set_modulate(Color(0.4,1,0.4))
			texture = box_texture[3]
		elif not owner.state_grappling:
			set_modulate(Color(1,1,0.4))
			texture = box_texture[4]
		else:
			set_modulate(Color(1,0.2,0.2))
			texture = box_texture[5]
	else:
		if not owner.can_spin and not owner.state_spinning:
			set_modulate(Color(0.2,0.2,0.2))
			texture = box_texture[0]
		elif owner.spin_speed == 0:
			set_modulate(Color(0.4,1,0.4))
			texture = box_texture[0]
		elif owner.spin_speed < owner.spin_strength:
			set_modulate(Color(1,1,0.4))
			texture = box_texture[1]
		else:
			set_modulate(Color(1,0.2,0.2))
			texture = box_texture[2]
