extends ActorAction
class_name ActionTremble

@export var strength: Vector2 = Vector2.ZERO
@export var duration: float = 5.0
@export var speed: float = 2.0
var remaining_duration: float = 0.0
var offset: Vector2 = Vector2.ZERO

func act(delta: float) -> void:
	super(delta)
	offset = next_tremble_offset()
	if remaining_duration > 0.0: remaining_duration -= delta
	if offset.is_zero_approx():
		action_transform.origin = Vector2.ZERO
	else:
		action_transform.origin = action_transform.origin.lerp(
			offset,
			speed * delta
		)


func run() -> void:
	remaining_duration = duration


func is_running() -> bool:
	return remaining_duration >= 0.0 and !offset.is_zero_approx()


func reset() -> void:
	super()
	remaining_duration = 0.0
	offset = Vector2.ZERO



func next_tremble_offset() -> Vector2:
	if remaining_duration > 0.0:
		return Vector2(
			randf_range(-1, 1) * strength.x,
			randf_range(-1, 1) * strength.y
		)
	else:
		return offset.lerp(Vector2.ZERO, .5)
