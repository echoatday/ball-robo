extends Sprite3D

@export var rebind_buttons: Array[Node3D]
@export var sensitivity_slider: Node3D
var current_button: Node3D
@onready var collision := $sensitivity_slider_body
var selected = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(0.2).timeout
	for button in rebind_buttons:
		current_button = button
		print(current_button)
		var action_name = button.name.split("_")[0]
		change_button_text(action_name)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	sensitivity_slider.position.z = -Globals.mouse_sensitivity + 0.5
	if owner.pilot_cast.get_collider() == collision:
		sensitivity_slider.selected = true
		var cast_point = get_parent().to_local(owner.pilot_cast.get_collision_point())
		cast_point.x -= 0.1
		cast_point.z = snappedf(cast_point.z, 0.2)
		sensitivity_slider.position.z = cast_point.z
		if Input.is_action_just_released("fire"):
			Globals.mouse_sensitivity = snappedf(-cast_point.z + 0.5, 0.1)
			Globals.save_options()
	elif Input.is_action_just_released("fire"):
		for button in rebind_buttons:
			if owner.pilot_cast.get_collider() == button.collision:
				current_button = button
				button.selected = true
				selected = true
	else:
		sensitivity_slider.selected = false
		

func _unhandled_input(event):
	if selected and event is not InputEventMouseMotion:
		var action_name = current_button.name.split("_")[0]
		if event is InputEventJoypadMotion:
			if abs(event.axis_value) > 0.5:
				Globals.set("input_" + action_name, event)
				InputMap.action_erase_events(action_name)
				InputMap.action_add_event(action_name,event)
				selected = false
				current_button.selected = false
				Globals.save_options()
		elif event.pressed:
			Globals.set("input_" + action_name, event)
			InputMap.action_erase_events(action_name)
			InputMap.action_add_event(action_name,event)
			selected = false
			current_button.selected = false
			Globals.save_options()
	
		change_button_text(action_name)
		
func change_button_text(action_name):
	var label_button = Globals.get("input_" + action_name)
	var label_code: String
	if label_button is InputEventKey:
		label_code = label_button.as_text_keycode()
		current_button.label.text = label_code.erase(2,100)
		match(label_code):
			"Up":
				current_button.label.text = "↑"
			"Down":
				current_button.label.text = "↓"
			"Left":
				current_button.label.text = "←"
			"Right":
				current_button.label.text = "→"
	elif label_button is InputEventMouseButton:
		label_code = str(label_button.button_index)
		current_button.label.text = "M" + label_code
	elif label_button is InputEventJoypadButton:
		label_code = label_button.button_index
		match(label_code):
			0:
				current_button.label.text = "✕"
			1:
				current_button.label.text = "○"
			2:
				current_button.label.text = "□"
			3:
				current_button.label.text = "△"
			4:
				current_button.label.text = "◀"
			5:
				current_button.label.text = "GU"
			6:
				current_button.label.text = "▶"
			7:
				current_button.label.text = "L3"
			8:
				current_button.label.text = "R3"
			9:
				current_button.label.text = "L1"
			10:
				current_button.label.text = "R1"
			11:
				current_button.label.text = "D↑"
			12:
				current_button.label.text = "D↓"
			13:
				current_button.label.text = "D←"
			14:
				current_button.label.text = "D→"
			_:
				current_button.label.text = "j?"
	elif label_button is InputEventJoypadMotion:
		label_code = label_button.axis
		match(label_code):
			JOY_AXIS_LEFT_X:
				current_button.label.text = "LX"
			JOY_AXIS_LEFT_Y:
				current_button.label.text = "LY"
			JOY_AXIS_RIGHT_X:
				current_button.label.text = "RX"
			JOY_AXIS_RIGHT_Y:
				current_button.label.text = "RY"
			JOY_AXIS_TRIGGER_LEFT:
				current_button.label.text = "L2"
			JOY_AXIS_TRIGGER_RIGHT:
				current_button.label.text = "R2"
