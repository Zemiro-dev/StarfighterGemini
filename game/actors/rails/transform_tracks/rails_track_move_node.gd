@tool
extends RailsTransformTrack
class_name RailsTrackMoveNode


@export var speed: float = 100.0
@export var max_duration: float = 0.0
@export var target_global_position: Vector2 = Vector2.ZERO
@export var target_radius: float = 1.0
var movement_transform := Transform2D()
var remaining_duration := 0.0
var _is_running := false


func _ready() -> void:
	super()
	finished.connect(func(): _is_running = false)
	if combination_style == RailsTrack.TransformCombinationStyle.DEFAULT:
		combination_style = RailsTrack.TransformCombinationStyle.TRANSLATE_ONLY


func sample() -> Transform2D:
	return movement_transform


func _physics_process(delta: float) -> void:
	if is_running() and _check_position():
		var target_local_position := target_vector()
		var gmotion := target_local_position.normalized() * speed * delta
		if gmotion.length() > target_local_position.length():
			gmotion = target_local_position
		movement_transform = movement_transform.translated(gmotion)
		_update_timers(delta)
		_check_timers(delta)


func _check_position() -> bool:
	if target_vector().length() <= target_radius:
		track_finished.emit()
		return false
	return true


func _update_timers(delta: float) -> void:
	if remaining_duration > 0.0 and max_duration > 0.0:
		remaining_duration -= delta


func _check_timers(_delta: float) -> void:
	if remaining_duration <= 0.0 and max_duration > 0.0:
		track_finished.emit()


func target_vector() -> Vector2:
	if !is_running() or !_node: return Vector2.ZERO
	return target_global_position - _node.global_position


func start(node: Node2D, base_transform: Transform2D = Transform2D.IDENTITY) -> void:
	super(node, base_transform)
	remaining_duration = max_duration
	_is_running = true


func reset() -> void:
	super()
	_check_marker()
	remaining_duration = 0.0
	_is_running = false
	movement_transform = Transform2D.IDENTITY


func is_running() -> bool:
	return _is_running


func _check_marker() -> void:
	if has_node('Marker2D'):
		target_global_position = get_node('Marker2D').global_position
