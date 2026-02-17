extends Node
class_name Steering


@export var steering_stats: SteeringStats
@export var power_multiplier: float = 1.0
var strategies: Array[SteeringStrategy]


func _ready() -> void:
	cache_strategies()


func cache_strategies() -> void:
	strategies = get_strategies()
	

func steer(velocity: Vector2, delta: float) -> Vector2:
	var combined_steering := Vector2.ZERO
	for strategy in strategies:
		var result := strategy.steer(self, velocity)
		combined_steering += result / strategies.size()
	var turn_around_dot := combined_steering.normalized().dot(velocity.normalized())
	var turn_around_power := 1.0 if turn_around_dot >= 0 else get_turn_around_multiplier()
	
	var acceleration := get_max_acceleration() * combined_steering * turn_around_power
	return velocity + acceleration * delta


func slow(velocity: Vector2, delta: float) -> Vector2:
	return velocity.move_toward(Vector2.ZERO, get_max_acceleration() * delta * 5.)


func get_strategies() -> Array[SteeringStrategy]:
	var _strategies: Array[SteeringStrategy] = [];
	for child in get_children():
		if child is SteeringStrategy:
			_strategies.append(child)
	return _strategies


func get_max_speed() -> float:
	return steering_stats.base_max_speed * power_multiplier


func get_max_acceleration() -> float:
	return steering_stats.base_max_acceleration * power_multiplier


func get_turn_around_multiplier() -> float:
	return steering_stats.turn_around_multiplier


func should_overspeed_break(velocity: Vector2) -> bool:
	return velocity.length() > get_max_speed()


func overspeed_break(velocity: Vector2) -> Vector2:
	return velocity.move_toward(velocity.normalized() * get_max_speed(), steering_stats.overspeed_break_force)
