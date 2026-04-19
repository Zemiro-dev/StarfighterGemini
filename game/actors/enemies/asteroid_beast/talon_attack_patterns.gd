@tool
extends Node2D
class_name TalonAttackPatterns


@onready var charge_path_follow_2d: PathFollow2D = $ChargePath2D/ChargePathFollow2D
@onready var target_follow_pattern: TargetFollowPattern = $TargetFollowPattern
@onready var target_follow_pattern_2: TargetFollowPattern = $TargetFollowPattern2
var conductors: Array[RailsConductor]


@export var player: Player
@export var moves: Array[String] = []

@export var is_playing: bool = false : set = _set_is_playing


func _ready() -> void:
	is_playing = false
	conductors = [
		$TalonAConductor,
		$TalonBConductor
	]
	for conductor in conductors:
		conductor.stop()


func _set_is_playing(v: bool):
	is_playing = v
	for conductor in conductors:
		conductor.stop()
	if is_playing:
		for i in range(moves.size()):
			if !moves[i].is_empty():
				if i < conductors.size():
					conductors[i].start(moves[i])
				
