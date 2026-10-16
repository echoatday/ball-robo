extends Node3D

var unlock_roll := true
var unlock_jump := true
var unlock_walljump := true
var unlock_lateralboost := true
var unlock_downboost := true
var unlock_bounce := true
var unlock_grapple := true
var unlock_spin := true
var unlock_waterproofing := true

var unlock_energy_1 := true
var unlock_energy_2 := true
var unlock_heat := true

@export_enum("unlock_door", "unlock_hatch", "unlock_sheet", "unlock_iris", "unlock_vault", "unlock_roll", "unlock_jump", "unlock_walljump", "unlock_lateralboost", "unlock_downboost", "unlock_bounce", "unlock_grapple", "unlock_spin", "unlock_waterproofing", "unlock_energy_1", "unlock_energy_2", "unlock_heat") var target_item: int
@export_enum("sitting", "yamcha", "kneeling") var ruin_model: int

var collected_state := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match(target_item):
		0:
			collected_state = Globals.unlock_door
		1:
			collected_state = Globals.unlock_hatch
		2:
			collected_state = Globals.unlock_sheet
		3:
			collected_state = Globals.unlock_iris
		4:
			collected_state = Globals.unlock_vault
		5:
			collected_state = Globals.unlock_roll
		6:
			collected_state = Globals.unlock_jump
		7:
			collected_state = Globals.unlock_walljump
		8:
			collected_state = Globals.unlock_lateralboost
		9:
			collected_state = Globals.unlock_downboost
		10:
			collected_state = Globals.unlock_bounce
		11:
			collected_state = Globals.unlock_grapple
		12:
			collected_state = Globals.unlock_spin
		13:
			collected_state = Globals.unlock_waterproofing
		14:
			collected_state = Globals.unlock_energy_1
		15:
			collected_state = Globals.unlock_energy_2
		16:
			collected_state = Globals.unlock_heat
	
	match(ruin_model):
		0:
			$RobotOutside0001.visible = true
			$RobotOutside0002.visible = false
			$RobotOutside0003.visible = false
			if collected_state:
				$RobotOutside0001/OmniLight3D.visible = false
		1:
			$RobotOutside0001.visible = false
			$RobotOutside0002.visible = true
			$RobotOutside0003.visible = false
			if collected_state:
				$RobotOutside0002/OmniLight3D.visible = false
		2:
			$RobotOutside0001.visible = false
			$RobotOutside0002.visible = false
			$RobotOutside0003.visible = true
			if collected_state:
				$RobotOutside0003/RobotArm0003.visible = false
				$RobotOutside0003/OmniLight3D.visible = false
			elif target_item != 11:
				$RobotOutside0003/RobotArm0003.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pickup_trigger_body_entered(body: Node3D) -> void:
	if not collected_state:
		match(target_item):
			0:
				Globals.unlock_door = true
			1:
				Globals.unlock_hatch = true
			2:
				Globals.unlock_sheet = true
			3:
				Globals.unlock_iris = true
			4:
				Globals.unlock_vault = true
			5:
				Globals.unlock_roll = true
			6:
				Globals.unlock_jump = true
			7:
				Globals.unlock_walljump = true
			8:
				Globals.unlock_lateralboost = true
			9:
				Globals.unlock_downboost = true
			10:
				Globals.unlock_bounce = true
			11:
				Globals.unlock_grapple = true
			12:
				Globals.unlock_spin = true
			13:
				Globals.unlock_waterproofing = true
			14:
				Globals.unlock_energy_1 = true
			15:
				Globals.unlock_energy_2 = true
			16:
				Globals.unlock_heat = true
		
		$RobotOutside0001/OmniLight3D.visible = false
		$RobotOutside0002/OmniLight3D.visible = false
		$RobotOutside0003/OmniLight3D.visible = false
		$RobotOutside0003/RobotArm0003.visible = false
		Globals.save_game()
