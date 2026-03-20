extends Node2D
class_name TopEffectsRoot


func _ready() -> void:
	GlobalSignals.request_top_effect_spawn.connect(spawn)


func spawn(effect: Node2D) -> void:
	add_child(effect)
