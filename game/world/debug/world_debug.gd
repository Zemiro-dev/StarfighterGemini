extends Node2D

@onready var texture_rect: TextureRect = $Stage/TextureRect
@export var scroll_velocity := Vector2(.001, 0)
var scroll := Vector2.ZERO
func _physics_process(delta: float) -> void:
	scroll += scroll_velocity * delta
	texture_rect.material.set("shader_parameter/offset", scroll)
