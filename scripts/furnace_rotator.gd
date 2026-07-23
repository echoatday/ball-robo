extends Node3D

@export var rotator := Node3D
@export var heatzone := Node3D

var lifted := false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	$AnimatableBody3D.rotate_y(0.003)
	if lifted and not Globals.player.is_on_floor():
		Globals.player.velocity.y += 0.1


func _on_area_3d_body_entered(body: Node3D) -> void:
	body.heat_level += 1
	lifted = true


func _on_area_3d_body_exited(body: Node3D) -> void:
	body.heat_level -= 1
	lifted = false
