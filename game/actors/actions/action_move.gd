extends ActorAction
class_name ActionMove

@export var movement: Vector2 = Vector2.ZERO
@export var travel_time: float = 5.0
@export var reverse_on_loop: bool = false
var heading: float = 1.0

var _tween: Tween

func act(delta: float) -> void:
	super(delta)


func run() -> void:
	if _tween:
		_tween.kill()
	_tween = create_tween()
	_tween.tween_property(self, "action_transform:origin", heading * movement, travel_time).as_relative()
	if reverse_on_loop:
		heading *= -1.0


func is_running() -> bool:
	return _tween.is_running() if _tween else false


func reset() -> void:
	super()
	if _tween:
		_tween.kill()
	heading = 1.0
