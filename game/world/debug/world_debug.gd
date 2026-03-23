extends Node2D


func _ready() -> void:
	GlobalSignals.world_ready.emit()
