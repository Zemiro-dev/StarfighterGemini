extends Node2D
class_name TargetFollowPattern


@onready var remote_transform_2d: RemoteTransform2D = $TargetFollowPath2D/PathFollow2D/RemoteTransform2D
@onready var path_update_cooldown_timer: Timer = $PathUpdateCooldownTimer
@onready var path_follow_2d: PathFollow2D = $TargetFollowPath2D/PathFollow2D
@onready var target_follow_path_2d: Path2D = $TargetFollowPath2D


@export var target_offset := Vector2.ZERO
@export var path_update_cd := 3.0
@export var path_update_cd_variance := .5
@export var speed := 300
@export var blocking_radius := 350
@export var blocking_actors: Array[GameActor.ActorType] = [
	GameActor.ActorType.UNKNOWN
]
@export_flags_2d_physics var blocking_mask: int
var follower: Node2D : set = _set_follower
var target: Node2D

func _ready() -> void:
	_update_timer_wait_time()

func _update_timer_wait_time() -> void:
	path_update_cooldown_timer.wait_time = path_update_cd + randf_range(-path_update_cd_variance, path_update_cd_variance)

func _physics_process(delta: float) -> void:
	if !target or !follower: return
	if path_update_cooldown_timer.is_stopped():
		_update_path()
	var next_progress = path_follow_2d.progress + speed * delta
	next_progress = min(next_progress, target_follow_path_2d.curve.get_baked_length())
	path_follow_2d.progress = next_progress


func _update_path() -> void:
	var start := follower.global_position
	var end := target.global_position + target_offset
	
	var offset := _offset_from_boundaries(end)
	end += offset
	var curve := Curve2D.new()
	curve.add_point(target_follow_path_2d.to_local(start))
	curve.add_point(target_follow_path_2d.to_local(end))
	target_follow_path_2d.curve = curve
	path_follow_2d.progress = 0.
	_update_timer_wait_time()
	path_update_cooldown_timer.start()

func _offset_from_boundaries(end: Vector2) -> Vector2:
	var query := PhysicsShapeQueryParameters2D.new()
	var circle_rid := PhysicsServer2D.circle_shape_create()
	PhysicsServer2D.shape_set_data(circle_rid, blocking_radius)
	var circle_xform := Transform2D(0., end)
	query.shape_rid = circle_rid
	query.transform = circle_xform
	query.collide_with_areas = true
	query.collide_with_bodies = true
	query.collision_mask = blocking_mask
	var results := get_world_2d().direct_space_state.collide_shape(query)
	if results.is_empty(): 
		return Vector2.ZERO
		
	var offset := Vector2.ZERO
	for i in range(results.size() / 2):
		var a = results[i * 2]
		var b = results[i * 2 + 1]
		var depth = b - a
		offset += depth
		
	PhysicsServer2D.free_rid(circle_rid)
	return offset


func _set_follower(new_follower: Node2D):
	follower = new_follower
	remote_transform_2d.remote_path = follower.get_path()
	path_update_cooldown_timer.stop()
