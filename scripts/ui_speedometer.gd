extends Label3D

func _physics_process(delta: float) -> void:
	var meter_speed = floor(owner.velocity.length())
	if Engine.get_physics_frames() % 2 == 0:
		var output := ""
		while(meter_speed > 0):
			if meter_speed > 100:
				pass
			elif meter_speed > 60 and int(meter_speed) % 8 != 0:
				pass
			elif meter_speed > 40 and int(meter_speed) % 4 != 0:
				pass
			elif meter_speed > 20 and int(meter_speed) % 2 != 0:
				pass
			else:
				output += "_\n"
			meter_speed -= 1
		text = output.reverse()
