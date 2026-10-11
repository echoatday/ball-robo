extends MeshInstance3D

@onready var pilot_cast = owner.pilot_cast
@onready var estop_button_body = $estop_button_body
@onready var glow = $glow
@onready var glow_bright = $glow_bright

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if owner.state_dead:
		mesh.top_radius = 0.3
		mesh.bottom_radius = 0.45
		if pilot_cast.get_collider() == estop_button_body:
			mesh.top_radius = 0.4
	else:
		mesh.top_radius = 0.4
		mesh.bottom_radius = 0.5
		if pilot_cast.get_collider() == estop_button_body:
			mesh.top_radius = 0.3
	
	if pilot_cast.get_collider() == estop_button_body:
		glow_bright.visible = true
	else:
		glow_bright.visible = false
