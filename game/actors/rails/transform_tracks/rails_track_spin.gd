@tool
extends RailsTransformTrackTween
class_name RailsTrackSpin


@export var spin_radians: float = 0.0
var rotation: float = 0.0
@export var transition_type: Tween.TransitionType = Tween.TRANS_SINE


func sample() -> Transform2D:
	return Transform2D(rotation, Vector2.ZERO)


func prepare_tween(tween: Tween) -> Tween:
	tween.tween_property(self, 'rotation', spin_radians * direction, duration).as_relative().set_trans(transition_type)
	return tween


func reset() -> void:
	super()
	rotation = 0.0
