extends MovementPattern
class_name TremblePattern2


@onready var remote_transform_2d: RemoteTransform2D = $RemoteTransform2D
@export var tremble_tracking_rate := 2.
var tremble_offset := Vector2.ZERO
var tremble_strength := 0.0
var tremble_timer := 0.0

func _physics_process(delta: float) -> void:
	tremble_offset = next_tremble_offset()
	if tremble_timer > 0.0: tremble_timer -= delta
	remote_transform_2d.position = remote_transform_2d.position.lerp(
		tremble_offset,
		tremble_tracking_rate * delta
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


func _set_moving_node(new_moving_node: Node2D) -> void:
	super(new_moving_node)
	if new_moving_node:
		remote_transform_2d.position = Vector2.ZERO
		remote_transform_2d.remote_path = new_moving_node.get_path()
	else:
		remote_transform_2d.remote_path = ''
