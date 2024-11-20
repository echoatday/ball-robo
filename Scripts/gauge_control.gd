extends Node

@export_enum("None","Energy","Heat") var type := 0
@export var gauge_needle: Node3D
@export var gauge_text: Label3D

func _physics_process(delta: float) -> void:
	match type:
		1: 
			gauge_move(owner.energy, 5, 4)
			text_change(owner.energy, 1)
		2: 
			gauge_move(owner.heat, 10, 1)
			text_change(owner.heat, 10)

# Move the gauge
func gauge_move(value, scale, shake) -> void:
	var needle_degrees = -(value / scale) + 30
	var needle_shake = int(value / (scale*10)) / shake
	gauge_needle.set_rotation_degrees(Vector3(0,randi_range(needle_degrees,needle_degrees-needle_shake),0))
	pass
	
func text_change(value, scale) -> void:
	if Engine.get_physics_frames() % 3 == 0:
		if scale == 1 and value < 10:
			gauge_text.text = str("00",value/scale)
		elif value < 100:
			gauge_text.text = str("0",value/scale)
		elif value < 1000:
			gauge_text.text = str(value/scale)
		else:
			gauge_text.text = str((value/scale)-(scale/10))
	pass