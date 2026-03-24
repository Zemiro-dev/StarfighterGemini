@tool
extends Node2D


@onready var pivot: Node2D = $Pivot
@export var pivot_scale: Vector2 = Vector2.ONE : set = _set_pivot_scale
var _position_delta := 0.0
var speed := 50
var direction := -1


func _ready() -> void:
	_set_pivot_scale(pivot_scale)
	print(rotation)


func  _set_pivot_scale(new_scale: Vector2):
	pivot_scale = new_scale
	if (pivot):
		pivot.scale = pivot_scale


func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	var position_delta = speed * direction * delta
	_position_delta += abs(position_delta)
	position += Vector2(position_delta, 0)
	if _position_delta > 100:
		direction *= -1
		_position_delta = 0
	pass
