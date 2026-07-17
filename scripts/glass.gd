extends Node3D


func _on_area_3d_body_entered(body: Node3D) -> void:
	if (body.velocity * abs(basis.z)).length() >= 12:
		$unbroken.visible = false
		$broken.visible = true
		$StaticBody3D/CollisionShape3D.set_deferred("disabled", true)
		$Area3D/CollisionShape3D.set_deferred("disabled", true)
		#body.velocity = -body.velocity
