extends Node2D
class_name TalonAttackPatterns


@onready var charge_path_follow_2d: PathFollow2D = $ChargePath2D/ChargePathFollow2D

@export var player: Player
@export var talons: Array[Node2D] = []


func _ready() -> void:
	patrol_path(charge_path_follow_2d, 10., 1.)
	


func _physics_process(delta: float) -> void:
	pass


func patrol_path(follower: PathFollow2D, duration: float, starting_progress: float = 0.) -> void:
	follower.progress_ratio = starting_progress
	var tween := follower.create_tween()
	tween.set_loops()
	tween.tween_property(follower, "progress_ratio", 0. if starting_progress >= .5 else 1., duration)
	tween.tween_property(follower, "progress_ratio", 1. if starting_progress >= .5 else 0., duration)
