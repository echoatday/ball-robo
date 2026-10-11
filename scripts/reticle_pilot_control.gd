extends Sprite3D

@export var pointer_texture: Array[Texture]
@onready var pilot_cast = owner.pilot_cast

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not owner.state_looking:
		visible = true
		if Input.is_action_pressed("fire"):
			texture = pointer_texture[2]
		elif pilot_cast.is_colliding():
			print(pilot_cast.get_collider())
			texture = pointer_texture[1]
		else:
			texture = pointer_texture[0]
	else:
		visible = false
