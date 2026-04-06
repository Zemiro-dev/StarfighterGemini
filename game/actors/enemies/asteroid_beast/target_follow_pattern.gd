extends Node2D
class_name TargetFollowPattern


@onready var remote_transform_2d: RemoteTransform2D = $TargetFollowPath2D/PathFollow2D/RemoteTransform2D
@onready var path_update_cooldown_timer: Timer = $PathUpdateCooldownTimer
@onready var path_follow_2d: PathFollow2D = $TargetFollowPath2D/PathFollow2D
@onready var target_follow_path_2d: Path2D = $TargetFollowPath2D


@export var speed := 500
var follower: Node2D : set = _set_follower
var target: Node2D


func _physics_process(delta: float) -> void:
	if !target or !follower: return
	if path_update_cooldown_timer.is_stopped():
		_update_path()
	var next_progress = path_follow_2d.progress + speed * delta
	next_progress = min(next_progress, target_follow_path_2d.curve.get_baked_length())
	path_follow_2d.progress = next_progress


func _update_path() -> void:
	var start := follower.global_position
	var end := target.global_position
	var curve := Curve2D.new()
	curve.add_point(target_follow_path_2d.to_local(start))
	curve.add_point(target_follow_path_2d.to_local(end))
	target_follow_path_2d.curve = curve
	path_follow_2d.progress = 0.
	path_update_cooldown_timer.start()


func _set_follower(new_follower: Node2D):
	follower = new_follower
	remote_transform_2d.remote_path = follower.get_path()
	path_update_cooldown_timer.stop()
