extends RailsTrack
class_name RailsTrackDelay

@export var delay: float = 5.0
var current_timer: SceneTreeTimer


func start(node: Node2D, base_transform: Transform2D = Transform2D.IDENTITY) -> void:
	super(node, base_transform)
	current_timer = get_tree().create_timer(delay)
	await current_timer.timeout
	## Makes sure we weren't stopped first
	if current_timer:
		if current_timer.time_left <= 0:
			track_finished.emit()


func is_running():
	return current_timer and current_timer.time_left <= 0


func stop() -> void:
	super()
	current_timer = null
