extends Node
class_name Steering

@onready var controller_steering: ControllerSteering = $ControllerSteering

@export var steering_stats: SteeringStats

func steer(velocity: Vector2, delta: float) -> Vector2:
	return controller_steering.steer(self, velocity)


func get_max_speed() -> float:
	return steering_stats.base_max_speed


func get_max_acceleration() -> float:
	return steering_stats.base_max_acceleration
