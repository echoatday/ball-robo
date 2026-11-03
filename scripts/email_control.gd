extends Sprite3D

@export var emails: Array[Node3D]
var selected_email := 0
var current_text: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if selected_email != 0:
		$email_text.text = get_node("email_" + str(selected_email)).email_text
	else:
		$email_text.text = "Connected to Internal Network."
	
