extends Node
class_name Controller


@export var controllable := true: set = set_controllable


func get_goal() -> Vector2:
	return Vector2.ZERO


func set_controllable(new_value: bool) -> void:
	controllable = new_value
