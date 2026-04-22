@tool
extends RailsTransformTrackTween
class_name RailsTrackMove

@export var movement: Vector2 = Vector2.ZERO
var movement_transform := Transform2D()
@export var transition_type: Tween.TransitionType = Tween.TRANS_LINEAR
@export var ease_type: Tween.EaseType = Tween.EASE_IN_OUT


func sample() -> Transform2D:
	return movement_transform


func prepare_tween(tween: Tween) -> Tween:
	tween.set_trans(transition_type)
	tween.set_ease(ease_type)
	tween.tween_property(
		self, "movement_transform:origin", direction * movement, duration
	).as_relative()
	return tween


func reset() -> void:
	super()
	movement_transform = Transform2D()
