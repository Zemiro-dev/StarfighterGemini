extends Controller
class_name PlayerController


func get_goal() -> Vector2:
	if !controllable: return Vector2.ZERO
	return Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
	)
