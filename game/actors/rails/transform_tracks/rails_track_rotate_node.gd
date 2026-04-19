@tool
extends RailsTransformTrack
class_name RailsTrackRotateNode

## Adding a marker 2d to this node will cause it to chase that position

@export var rads_per_second: float = TAU
@export var max_duration: float = 0.0
@export var target_global_rotation: float = 0.0
@export var tolerance: float = TAU/2024
var movement_transform := Transform2D()
var remaining_duration := 0.0
var _is_running := false


func _ready() -> void:
	super()
	finished.connect(func(): _is_running = false)
	if combination_style == RailsTrack.TransformCombinationStyle.DEFAULT:
		combination_style = RailsTrack.TransformCombinationStyle.ROTATE_ONLY


func sample() -> Transform2D:
	return movement_transform


func _physics_process(delta: float) -> void:
	if is_running() and _check_rotation():
		var max_rotation = remaining_rotation()
		var frame_rotation = sign(max_rotation) * rads_per_second * delta
		if abs(frame_rotation) > abs(max_rotation):
			frame_rotation = max_rotation
		movement_transform = movement_transform.rotated(frame_rotation)
		_update_timers(delta)
		_check_timers(delta)


func _check_rotation() -> bool:
	if abs(remaining_rotation()) <= tolerance:
		track_finished.emit()
		return false
	return true


func _update_timers(delta: float) -> void:
	if remaining_duration > 0.0 and max_duration > 0.0:
		remaining_duration -= delta


func _check_timers(_delta: float) -> void:
	if remaining_duration <= 0.0 and max_duration > 0.0:
		track_finished.emit()


func remaining_rotation() -> float:
	return (
		Vector2.from_angle(_node.global_rotation)
		.angle_to(Vector2.from_angle(target_global_rotation))
	)
	


func start(node: Node2D, base_transform: Transform2D = Transform2D.IDENTITY) -> void:
	super(node, base_transform)
	remaining_duration = max_duration
	_is_running = true


func reset() -> void:
	super()
	remaining_duration = 0.0
	_is_running = false
	movement_transform = Transform2D.IDENTITY


func is_running() -> bool:
	return _is_running
