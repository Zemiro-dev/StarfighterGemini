extends Controller
class_name PlayerController

var locked_goal: Vector2 = Vector2.ZERO
var is_goal_locked: bool = false: set = set_is_goal_locked 

func get_goal() -> Vector2:
	if !controllable: return Vector2.ZERO
	if is_goal_locked: return locked_goal
	return Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
	)


func dash_pressed() -> bool:
	return Input.is_action_pressed("dash")
	

func set_is_goal_locked(new_value: bool) -> void:
	if (new_value):
		locked_goal = get_goal().normalized()
		if locked_goal.is_zero_approx():
			locked_goal = Vector2.RIGHT
	is_goal_locked = new_value


func get_target_direction() -> Vector2:
	if !controllable: return Vector2.ZERO
	return Vector2(
		Input.get_axis("target_left", "target_right"),
		Input.get_axis("target_up", "target_down")
	)
