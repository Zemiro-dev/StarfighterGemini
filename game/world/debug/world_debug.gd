extends Node2D

@onready var talon_attack_patterns: TalonAttackPatterns = $Stage/TalonAttackPatterns


func _ready() -> void:
	GlobalSignals.world_ready.emit()
	talon_attack_patterns.is_playing = true
