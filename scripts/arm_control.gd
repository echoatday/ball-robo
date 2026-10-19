extends Path3D

@export var distance_interval = 1.0
var frequency = 3

func _physics_process(_delta) -> void:
		_arm_movement()
	

func _update_multimesh(length):
	var path_length: float = curve.get_baked_length()
	var count
	if length == 0:
		count = ceil(path_length / distance_interval)
	else: 
		count = length
	
	var outer_arm = $ArmMesh1.multimesh
	var inner_arm = $ArmMesh2.multimesh
	outer_arm.set_instance_count(count)
	inner_arm.instance_count = count
	
	$ClawMesh.position = curve.get_point_position(3)
	
	for i in range(0,count):
		var curve_distance = distance_interval * i
		var curve_position = curve.sample_baked(curve_distance,true)
		
		var basis = Basis()
		
		var up = curve.sample_baked_up_vector(curve_distance,true)
		var forward = curve_position.direction_to(curve.sample_baked(curve_distance+0.1,true))
		
		basis.y = up
		basis.x = forward.cross(up).normalized()
		basis.z = -forward
		
		var transform = Transform3D(basis, curve_position)
		var size = clampf((curve_position.z-20) * -0.04,1,4)
		if i%frequency == 0 and i < 12:
			outer_arm.set_instance_transform(i,transform.scaled_local(Vector3(size,size,1)))
		else:
			inner_arm.set_instance_transform(i,transform.scaled_local(Vector3(size,size,1)))

func _arm_movement():
	var point_3_base_position = Vector3(0.5,-3.0,-6.0)
	var point_2_base_position = Vector3(1.0,-4.0,-2.0)
	var point_1_base_position = Vector3(2.0,-1.2,1.0)
	var cable_material = $ArmMesh2.multimesh.mesh.material
	var path_length: float = curve.get_baked_length()
	
	if owner.state_grappling:
		$ClawMesh.visible = true
		$ClawFist.visible = false
		$ClawGrabCube.visible = false
		$ClawGrabBrain.visible = false
		frequency = 3
		cable_material.uv1_offset.y += 0.02
		curve.set_point_position(3,to_local(owner.grapple_hook_position)*0.8)
		curve.set_point_position(2,Vector3(2.0,-2.0,-1.0))
	else:
		$ClawMesh.visible = false
		match Globals.holding_item:
			0:
				$ClawFist.visible = true
			1: 
				$ClawGrabCube.visible = true
			2:
				$ClawGrabBrain.visible = true
		frequency = 3
		cable_material.uv1_offset.y = 0
		curve.set_point_position(3,point_3_base_position)
		curve.set_point_position(2,point_2_base_position)
		#curve.set_point_position(1,point_1_base_position)
	
	if not Globals.unlock_grapple:
		$ClawMesh.visible = false
		$ClawFist.visible = false
		$ClawGrabCube.visible = false
		$ClawGrabBrain.visible = false

func _on_curve_changed() -> void:
	if Globals.unlock_grapple:
		_update_multimesh(0)
	else:
		_update_multimesh(2)
