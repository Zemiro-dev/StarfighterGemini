extends Node2D
class_name TalonAttackPatterns


@onready var charge_path_follow_2d: PathFollow2D = $ChargePath2D/ChargePathFollow2D
@onready var target_follow_pattern: TargetFollowPattern = $TargetFollowPattern
@onready var target_follow_pattern_2: TargetFollowPattern = $TargetFollowPattern2
@onready var talon_0_conductor: RailsConductor = $TalonAConductor
@onready var talon_1_conductor: RailsConductor = $TalonBConductor


@export var player: Player
@export var talons: Array[Node2D] = []


func _ready() -> void:
	#talon_0_conductor.drive(talons[0])
	#talon_0_conductor.start("TalonACycle")
	talon_1_conductor.drive(talons[1])
	talon_1_conductor.start("PTest2")
	#target_follow_pattern.target_offset = Vector2.ZERO
	#target_follow_pattern.target = player
	#target_follow_pattern.follower = talons[1]
	
	#target_follow_pattern_2.target_offset = Vector2(200., 100.)
	#target_follow_pattern_2.target = player
	#target_follow_pattern_2.follower = talons[0]
	
	#patrol_path(charge_path_follow_2d, 10.)
	
	#talons[0].can_turn = false
	#tremble_pattern.trembler = talons[0]
	#tremble_pattern.tremble(1000., 200.)
	
	#talons[1].can_turn = false
	#spin_pattern.toy = talons[1]
	


func _physics_process(_delta: float) -> void:
	pass


func patrol_path(follower: PathFollow2D, duration: float) -> void:
	follower.progress_ratio = 0.
	var tween := follower.create_tween()
	tween.set_loops()
	tween.tween_property(follower, "progress_ratio", 1., duration)
	tween.tween_property(follower, "progress_ratio", 0., 0.)
