extends Sprite3D

@export var fps_buttons: Array[Node3D]
@export var resolution_buttons: Array[Node3D]
@export var window_buttons: Array[Node3D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.load_options()
	match Globals.max_framerate:
		30:
			fps_buttons[0].selected = true
		60:
			fps_buttons[1].selected = true
		120:
			fps_buttons[2].selected = true
		144:
			fps_buttons[3].selected = true
		240:
			fps_buttons[4].selected = true
	match Globals.resolution_scale:
		0.25:
			resolution_buttons[0].selected = true
		0.5:
			resolution_buttons[1].selected = true
		0.67:
			resolution_buttons[2].selected = true
		0.85:
			resolution_buttons[3].selected = true
		1.0:
			resolution_buttons[4].selected = true
		1.5:
			resolution_buttons[5].selected = true
	
	match Globals.windowed_mode:
		0:
			window_buttons[0].selected = true
		3:
			window_buttons[1].selected = true
		4:
			window_buttons[2].selected = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_released("fire") and Globals.player.state_looking == false:
		for i in fps_buttons.size():
			var button = fps_buttons[i]
			if button.clicked:
				button.selected = true
				match i:
					0:
						Globals.max_framerate = 30
						fps_buttons[1].selected = false
						fps_buttons[2].selected = false
						fps_buttons[3].selected = false
						fps_buttons[4].selected = false
					1:
						Globals.max_framerate = 60
						fps_buttons[0].selected = false
						fps_buttons[2].selected = false
						fps_buttons[3].selected = false
						fps_buttons[4].selected = false
					2:
						Globals.max_framerate = 120
						fps_buttons[0].selected = false
						fps_buttons[1].selected = false
						fps_buttons[3].selected = false
						fps_buttons[4].selected = false
					3:
						Globals.max_framerate = 144
						fps_buttons[0].selected = false
						fps_buttons[1].selected = false
						fps_buttons[2].selected = false
						fps_buttons[4].selected = false
					4:
						Globals.max_framerate = 240
						fps_buttons[0].selected = false
						fps_buttons[1].selected = false
						fps_buttons[2].selected = false
						fps_buttons[3].selected = false
				Globals.save_options()
		Engine.max_fps = Globals.max_framerate
		
		#var current_resolution_scale = get_viewport().scaling_3d_scale
		for i in resolution_buttons.size():
			var button = resolution_buttons[i]
			if button.clicked:
				button.selected = true
				match i:
					0:
						Globals.resolution_scale = 0.25
						resolution_buttons[1].selected = false
						resolution_buttons[2].selected = false
						resolution_buttons[3].selected = false
						resolution_buttons[4].selected = false
						resolution_buttons[5].selected = false
					1:
						Globals.resolution_scale = 0.5
						resolution_buttons[0].selected = false
						resolution_buttons[2].selected = false
						resolution_buttons[3].selected = false
						resolution_buttons[4].selected = false
						resolution_buttons[5].selected = false
					2:
						Globals.resolution_scale = 0.67
						resolution_buttons[0].selected = false
						resolution_buttons[1].selected = false
						resolution_buttons[3].selected = false
						resolution_buttons[4].selected = false
						resolution_buttons[5].selected = false
					3:
						Globals.resolution_scale = 0.85
						resolution_buttons[0].selected = false
						resolution_buttons[1].selected = false
						resolution_buttons[2].selected = false
						resolution_buttons[4].selected = false
						resolution_buttons[5].selected = false
					4:
						Globals.resolution_scale = 1.0
						resolution_buttons[0].selected = false
						resolution_buttons[1].selected = false
						resolution_buttons[2].selected = false
						resolution_buttons[3].selected = false
						resolution_buttons[5].selected = false
					5:
						Globals.resolution_scale = 1.5
						resolution_buttons[0].selected = false
						resolution_buttons[1].selected = false
						resolution_buttons[2].selected = false
						resolution_buttons[3].selected = false
						resolution_buttons[4].selected = false
				Globals.save_options()
		get_viewport().scaling_3d_scale = Globals.resolution_scale
		
		for i in window_buttons.size():
			var button = window_buttons[i]
			if button.clicked:
				button.selected = true
				match i:
					0:
						Globals.windowed_mode = 0
						window_buttons[1].selected = false
						window_buttons[2].selected = false
					1:
						Globals.windowed_mode = 3
						window_buttons[0].selected = false
						window_buttons[2].selected = false
					2:
						Globals.windowed_mode = 4
						window_buttons[0].selected = false
						window_buttons[1].selected = false
				Globals.save_options()
		DisplayServer.window_set_mode(Globals.windowed_mode)
