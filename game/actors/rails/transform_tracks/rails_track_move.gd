extends RailsTransformTrackTween
class_name RailsTrackMove

@export var movement: Vector2 = Vector2.ZERO
var movement_transform := Transform2D()


func sample() -> Transform2D:
	return movement_transform


func prepare_tween(tween: Tween) -> Tween:
	tween.tween_property(self, "movement_transform:origin", direction * movement, duration).as_relative()
	return tween


func reset() -> void:
	super()
	movement_transform = Transform2D()
