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
		
	var desired_velocity = combined_steering * get_max_speed()
	var steering_acceleration = (desired_velocity - velocity).normalized() * get_acceleration(velocity)
		
	var turn_around_dot := combined_steering.normalized().dot(velocity.normalized())
	var turn_around_power := 1.0 if turn_around_dot >= 0.0 else get_turn_around_multiplier()
	steering_acceleration *= turn_around_power
	return velocity + steering_acceleration * delta


func get_acceleration(velocity: Vector2) -> float:
	if (!steering_stats.acceleration_curve): return get_max_acceleration()
	var speed_ratio = clampf(velocity.length() / get_max_speed(), 0.0, 1.0)
	var accel_ratio = steering_stats.acceleration_curve.sample(speed_ratio)
	return accel_ratio * get_max_acceleration()


func slow(velocity: Vector2, delta: float) -> Vector2:
	return velocity.move_toward(Vector2.ZERO, get_acceleration(velocity) * delta * steering_stats.turn_around_multiplier)


func overspeed_break(velocity: Vector2, delta) -> Vector2:
	return velocity.move_toward(velocity.normalized() * get_max_speed(), steering_stats.overspeed_break_force * delta)


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
