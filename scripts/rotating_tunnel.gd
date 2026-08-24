extends Node3D

@export var tunnel: AnimatableBody3D
@export var fan: AnimatableBody3D
@export var grate: AnimatableBody3D
@export var speed := 6
@export var grate_on := true
@export var fan_on := true

@onready var rotate_speed = speed * -0.001

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not fan_on:
		fan.queue_free()
	if not grate_on:
		grate.queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	tunnel.rotate_x(rotate_speed)
	if fan_on:
		fan.rotate_x(rotate_speed)
	if grate_on:
		grate.rotate_x(rotate_speed)
