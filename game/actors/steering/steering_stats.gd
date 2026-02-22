extends Resource
class_name SteeringStats

@export var base_max_speed: float = 500.0
@export var base_max_acceleration: float = 2500.0
@export var turn_around_multiplier: float = 2.0
@export var overspeed_break_force: float = 10000.0
@export var dash_duration: float = .07
@export var dash_cooldown: float = 1.0
@export var dash_multiplier: float = 10.0
@export var acceleration_curve: Curve
