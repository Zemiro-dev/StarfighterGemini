extends ActorAction
class_name ActionSpin

@export var rotation: float = 0.0
@export var spin_radians: float = 0.0
@export var spin_time: float = 5.0
@export var is_looping: bool = true
@export var transition_type: Tween.TransitionType = Tween.TRANS_SINE

var _tween: Tween

func act(delta: float) -> void:
	super(delta)
	action_transform = Transform2D(rotation, Vector2.ZERO)


func run() -> void:
	if _tween:
		_tween.kill()
	_tween = create_tween()
	if is_looping:
		_tween.set_loops()
	_tween.tween_property(self, 'rotation', spin_radians, spin_time).as_relative().set_trans(transition_type)


func is_running() -> bool:
	return _tween.is_running() if _tween else false


func reset() -> void:
	super()
	if _tween:
		_tween.kill()
	rotation = 0
