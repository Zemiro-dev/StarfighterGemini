extends Node2D

@onready var last_turn_position := global_position
@onready var pivot: Node2D = $Pivot

@export var pivot_scale: Vector2 = Vector2.ONE : set = _set_pivot_scale
@export var min_delta_to_turn := 2.0


func _ready() -> void:
	_set_pivot_scale(pivot_scale)


func _physics_process(delta: float) -> void:
	var position_delta = global_position - last_turn_position;
	var heading = sign(position_delta)
	if !is_zero_approx(heading.x) and abs(position_delta.x) >= min_delta_to_turn:
		pivot_scale.x = heading.x
		last_turn_position = global_position


func  _set_pivot_scale(new_scale: Vector2):
	pivot_scale = new_scale
	if (pivot):
		pivot.scale = pivot_scale
