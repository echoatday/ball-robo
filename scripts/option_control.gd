extends Sprite3D

@export var fps_buttons: Array[Node3D]
@export var resolution_buttons: Array[Node3D]
@export var window_buttons: Array[Node3D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	resolution_buttons[5].selected = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_released("fire") and Globals.player.state_looking == false:
		var new_max_fps = 60
		fps_buttons[1].selected = true
		for i in fps_buttons.size():
			var button = fps_buttons[i]
			if button.clicked:
				button.selected = true
				match i:
					0:
						new_max_fps = 30
						fps_buttons[1].selected = false
						fps_buttons[2].selected = false
						fps_buttons[3].selected = false
						fps_buttons[4].selected = false
					1:
						new_max_fps = 60
						fps_buttons[0].selected = false
						fps_buttons[2].selected = false
						fps_buttons[3].selected = false
						fps_buttons[4].selected = false
					2:
						new_max_fps = 120
						fps_buttons[0].selected = false
						fps_buttons[1].selected = false
						fps_buttons[3].selected = false
						fps_buttons[4].selected = false
					3:
						new_max_fps = 144
						fps_buttons[0].selected = false
						fps_buttons[1].selected = false
						fps_buttons[2].selected = false
						fps_buttons[4].selected = false
					4:
						new_max_fps = 240
						fps_buttons[0].selected = false
						fps_buttons[1].selected = false
						fps_buttons[2].selected = false
						fps_buttons[3].selected = false
		Engine.max_fps = new_max_fps
		
		var current_resolution_scale = get_viewport().scaling_3d_scale
		var new_resolution_scale = 1.0
		resolution_buttons[4].selected = true
		for i in resolution_buttons.size():
			var button = resolution_buttons[i]
			if button.clicked:
				button.selected = true
				match i:
					0:
						new_resolution_scale = 0.25
						resolution_buttons[1].selected = false
						resolution_buttons[2].selected = false
						resolution_buttons[3].selected = false
						resolution_buttons[4].selected = false
						resolution_buttons[5].selected = false
					1:
						new_resolution_scale = 0.5
						resolution_buttons[0].selected = false
						resolution_buttons[2].selected = false
						resolution_buttons[3].selected = false
						resolution_buttons[4].selected = false
						resolution_buttons[5].selected = false
					2:
						new_resolution_scale = 0.67
						resolution_buttons[0].selected = false
						resolution_buttons[1].selected = false
						resolution_buttons[3].selected = false
						resolution_buttons[4].selected = false
						resolution_buttons[5].selected = false
					3:
						new_resolution_scale = 0.85
						resolution_buttons[0].selected = false
						resolution_buttons[1].selected = false
						resolution_buttons[2].selected = false
						resolution_buttons[4].selected = false
						resolution_buttons[5].selected = false
					4:
						new_resolution_scale = 1.0
						resolution_buttons[0].selected = false
						resolution_buttons[1].selected = false
						resolution_buttons[2].selected = false
						resolution_buttons[3].selected = false
						resolution_buttons[5].selected = false
					5:
						new_resolution_scale = 1.5
						resolution_buttons[0].selected = false
						resolution_buttons[1].selected = false
						resolution_buttons[2].selected = false
						resolution_buttons[3].selected = false
						resolution_buttons[4].selected = false
		get_viewport().scaling_3d_scale = new_resolution_scale
		
		var new_window_mode = 0
		window_buttons[1].selected = true
		for i in window_buttons.size():
			var button = window_buttons[i]
			if button.clicked:
				button.selected = true
				match i:
					0:
						new_window_mode = 0
						window_buttons[1].selected = false
						window_buttons[2].selected = false
					1:
						new_window_mode = 3
						window_buttons[0].selected = false
						window_buttons[2].selected = false
					2:
						new_window_mode = 4
						window_buttons[0].selected = false
						window_buttons[1].selected = false
		DisplayServer.window_set_mode(new_window_mode)

func _save_options() -> void:
	pass
