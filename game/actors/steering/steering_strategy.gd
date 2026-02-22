extends Node
class_name SteeringStrategy


## Vector indicating the direction and speed this steering strategy
## would like to be going. A vector with length between 0 and 1 
## which indicates the speed as a ratio of max speed.
func steer(steering: Steering, velocity: Vector2) -> Vector2:
	return Vector2.ZERO
