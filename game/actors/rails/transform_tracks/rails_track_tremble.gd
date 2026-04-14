extends RailsTransformTrack
class_name RailsTrackTremble

@export var strength: Vector2 = Vector2.ZERO
@export var duration: float = 5.0
@export var speed: float = 2.0
var remaining_duration: float = 0.0
var target_offset: Vector2 = Vector2.ZERO
var current_offset: Vector2 = Vector2.ZERO


func sample() -> Transform2D:
	return Transform2D(0.0, current_offset)


func _physics_process(delta: float) -> void:
	target_offset = next_tremble_offset()
	if remaining_duration > 0.0:
		if remaining_duration - delta <= 0.0:
			track_finished.emit()
		remaining_duration -= delta
	if target_offset.is_zero_approx():
		current_offset = Vector2.ZERO
	else:
		current_offset = current_offset.lerp(
			target_offset,
			speed * delta
		)


func start(node: Node2D) -> void:
	remaining_duration = duration
	super(node)


func is_running() -> bool:
	return remaining_duration >= 0.0 or !current_offset.is_zero_approx()


func reset() -> void:
	super()
	remaining_duration = 0.0
	target_offset = Vector2.ZERO
	current_offset = Vector2.ZERO


func next_tremble_offset() -> Vector2:
	if remaining_duration > 0.0:
		return Vector2(
			randf_range(-1, 1) * strength.x,
			randf_range(-1, 1) * strength.y
		)
	else:
		return target_offset.lerp(Vector2.ZERO, .5)
