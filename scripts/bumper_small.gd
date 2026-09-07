extends Node3D


func _on_area_3d_body_entered(body: Node3D) -> void:
	body.velocity = -body.get_real_velocity()
	if body.velocity.length() < 12:
		body.velocity = body.velocity * 2
	if body.is_on_floor():
		body.velocity.y += 2


func _on_area_3d_body_exited(_body: Node3D) -> void:
	$bumper.scale = Vector3(1.3,1.3,1.3)
	$Timer.start()


func _on_timer_timeout() -> void:
	$bumper.scale = Vector3(1,1,1)
