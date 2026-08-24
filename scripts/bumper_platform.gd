extends Node3D

const power = 14

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_top_area_body_entered(body: Node3D) -> void:
	body.can_boost = true
	body.can_spin = true
	if body.velocity.y > -power:
		body.velocity.y = power
	else:
		body.velocity.y = -body.velocity.y + 2


func _on_bottom_area_body_entered(body: Node3D) -> void:
	body.can_boost = true
	body.can_spin = true
	if body.velocity.y < power:
		body.velocity.y = -power
	else:
		body.velocity.y = -body.velocity.y + 2
