extends MeshInstance3D

@export var sphere: Node3D

func _physics_process(delta: float) -> void:
	rotation.z = sphere.rotation.x
