extends Node2D

var _position_delta := 0.0
var speed := 50
var direction := -1
func _physics_process(delta: float) -> void:
	var position_delta = speed * direction * delta
	_position_delta += abs(position_delta)
	position += Vector2(position_delta, 0)
	if _position_delta > 100:
		direction *= -1
		_position_delta = 0
	pass
