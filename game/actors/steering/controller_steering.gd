extends SteeringStrategy
class_name ControllerSteering

@export var controller: Controller


func steer(steering: Steering, velocity: Vector2) -> Vector2:
	return controller.get_goal()
