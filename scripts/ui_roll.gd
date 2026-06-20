extends MeshInstance3D

@export var sphere: Node3D

func _physics_process(delta: float) -> void:
	rotation_degrees.z = sphere.rotation_degrees.x+1.5
