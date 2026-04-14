extends Node2D
class_name MovementPattern

@export var moving_node: Node2D: set = _set_moving_node

func _set_moving_node(new_moving_node: Node2D) -> void:
	moving_node = new_moving_node
