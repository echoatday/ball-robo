extends Label3D

var current_level: int

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match current_level:
		24:
			text = "Moonlit\nCave"
		25:
			text = "Power\nShovel"
		26:
			text = "Pipe\nNetwork"
		34:
			text = "Outer\nHull"
		35:
			text = "Raw\nMaterials"
		36:
			text = "Waste\nDisposal"
		44:
			text = "Habitation"
		45:
			text = "Blast\nFurnace"
		46:
			text = "Cooling\nSystem"
		54:
			text = "Control\nDeck"
		55:
			text = "Forge\nWorks"
		56:
			text = "Engine\nBlock"
