@tool
extends Node2D

@onready var starfield_1: TextureRect = $Stage/Starfield1
@export var scroll_velocity := Vector2(.001, 0)
var scroll := Vector2.ZERO
func _physics_process(delta: float) -> void:
	scroll += scroll_velocity * delta
	starfield_1.material.set("shader_parameter/offset", scroll)
