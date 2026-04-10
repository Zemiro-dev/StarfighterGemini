extends Node2D
class_name TremblePattern


@onready var remote_transform_2d: RemoteTransform2D = $RemoteTransform2D
@export var trembler: Node2D : set = _set_trembler
@export var offset_tracking_rate := 2.

var tremble_offset := Vector2.ZERO
var tremble_strength := 0.0
var tremble_timer := 0.0


func _physics_process(delta: float) -> void:
	tremble_offset = next_tremble_offset()
	if tremble_timer > 0.0: tremble_timer -= delta
	remote_transform_2d.position = remote_transform_2d.position.lerp(
		tremble_offset,
		offset_tracking_rate * delta
	)


func next_tremble_offset() -> Vector2:
	if tremble_timer > 0.0:
		return Vector2(
			randf_range(-1, 1) * tremble_strength,
			randf_range(-1, 1) * tremble_strength
		)
	else:
		return tremble_offset.lerp(Vector2.ZERO, .5)


func tremble(duration: float, strength: float):
	tremble_timer = duration
	tremble_strength = strength


func _set_trembler(new_trembler: Node2D):
	trembler = new_trembler
	if trembler:
		global_position = trembler.global_position
		remote_transform_2d.position = Vector2.ZERO
		remote_transform_2d.remote_path = trembler.get_path()
	else:
		remote_transform_2d.remote_path = ''
