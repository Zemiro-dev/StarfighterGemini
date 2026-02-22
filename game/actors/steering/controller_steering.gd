extends SteeringStrategy
class_name ControllerSteering

@export var controller: Controller


## Steering based on player controller
##
## Okay minor thing. Do I want the controller to indicate where I want to
## move or the thrust I want to apply?
## If it's the thrust I might need to think about this. Idk play with it
func steer(steering: Steering, velocity: Vector2) -> Vector2:
	var goal := controller.get_goal()
	goal.limit_length(1.0)
	return goal
