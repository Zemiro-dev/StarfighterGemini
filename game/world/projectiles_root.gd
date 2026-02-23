extends Node2D
class_name ProjectilesRoot


func _ready() -> void:
	GlobalSignals.request_projectile_spawn.connect(spawn)


func spawn(projectile: Node2D) -> void:
	add_child(projectile)
