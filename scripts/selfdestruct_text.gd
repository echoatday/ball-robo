extends Label3D

@export var spotlight = SpotLight3D

func _physics_process(_delta: float) -> void:
	if not Globals.self_destruct:
		spotlight.light_color = Color(1.0,1.0,1.0)
		$TimerSelfDestruct.start()
		set_visible(false)
	elif $TimerSelfDestruct.is_stopped():
		Globals.player.state_dead = true
	else:
		spotlight.light_color = Color(1.0,0.8,0.8)
		set_visible(true)
		var milliseconds = int($TimerSelfDestruct.get_time_left() * 100) % 100
		var seconds = int($TimerSelfDestruct.get_time_left()) % 60
		var minutes = int($TimerSelfDestruct.get_time_left()) / 60
		var time_left = str(minutes).pad_zeros(2) + ":" + str(seconds).pad_zeros(2) + ":" + str(milliseconds).pad_zeros(2)
		text = time_left
