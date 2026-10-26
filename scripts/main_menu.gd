extends Sprite3D

enum {GAME, MEMORY, OPTIONS, QUIT}

var current_menu := 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match(current_menu):
		GAME:
			$game_menu.visible = false
			$memory_menu.visible = true
			$options_menu.visible = true
			$quit_menu.visible = true
			
			$game_section.visible = true
			$memory_section.visible = false
			$quit_section.visible = false
		MEMORY:
			$game_menu.visible = true
			$memory_menu.visible = false
			$options_menu.visible = true
			$quit_menu.visible = true
			
			$game_section.visible = false
			$memory_section.visible = true
			$quit_section.visible = false
		OPTIONS:
			$game_menu.visible = true
			$memory_menu.visible = true
			$options_menu.visible = false
			$quit_menu.visible = true
			
			$game_section.visible = false
			$memory_section.visible = false
			$quit_section.visible = false
		QUIT:
			$game_menu.visible = true
			$memory_menu.visible = true
			$options_menu.visible = true
			$quit_menu.visible = false
			
			$game_section.visible = false
			$memory_section.visible = false
			$quit_section.visible = true
