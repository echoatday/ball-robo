extends Node3D

@export var skylight := false

func _physics_process(_delta: float) -> void:
	if $Area3D.overlaps_body(Globals.player):
			if Globals.player.state_boosting and Globals.player.state_rolling == skylight:
				_break_glass()
			elif Input.is_action_just_released("fire") and Globals.player.spin_speed >= Globals.player.spin_strength:
				_break_glass()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if (body.velocity * abs(ceil(basis.z))).length() >= 12:
		_break_glass()

func _break_glass() -> void:
	$unbroken.visible = false
	$broken.visible = true
	$StaticBody3D/CollisionShape3D.set_deferred("disabled", true)
	$Area3D/CollisionShape3D.set_deferred("disabled", true)
