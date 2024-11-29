extends Area3D

@export var heat_level := -1
@export var color_box: Node3D

enum {NORTH = 90, SOUTH = -90, WEST = 180, EAST = 0}
@onready var world = get_tree().current_scene
@onready var door = [$"../DoorNorth", $"../DoorSouth", $"../DoorWest", $"../DoorEast"]
var this_room
@onready var primary_room = false
# NORTH/SOUTH/EAST/WEST, door_rotation, global_position, spawn_position, spawn_room

func _ready() -> void:
	var heat_color = heat_level*0.3
	if not this_room:
		this_room = 75

func _on_body_entered(body: Node3D) -> void:
	#world.environment.fog_density = heat_level * 0.02
	body.heat_level = heat_level
	
	self.primary_room = true
	for child in world.get_children():
		if "primary_room" in child.get_child(1) and not child.get_child(1).primary_room:
			world.remove_child(child)
	
	for current in door:
		if is_instance_valid(current):
			var direction := Vector3.ZERO
			match int(current.door_rotation):
				NORTH:
					current.spawn_room = this_room - 10
					direction = Vector3(1,0,0)
				SOUTH:
					current.spawn_room = this_room + 10
					direction = Vector3(-1,0,0)
				WEST:
					current.spawn_room = this_room - 1
					direction = Vector3(0,0,-1)
				EAST:
					current.spawn_room = this_room + 1
					direction = Vector3(0,0,1)
			
			if is_instance_valid(StationMap.rooms[current.spawn_room]):
				var instance = StationMap.rooms[current.spawn_room].instantiate()
				instance.get_child(1).this_room = current.spawn_room
				
				current.spawn_position = owner.global_position
				current.spawn_position += direction * (owner.get_child(0).get_child(0).get_child(0).get_aabb().size.abs()/2)
				current.spawn_position += direction * (instance.get_child(0).get_child(0).get_child(0).get_aabb().size.abs()/2)
				instance.global_position = current.spawn_position
				world.add_child(instance)


func _on_body_exited(body: Node3D) -> void:
	self.primary_room = false
