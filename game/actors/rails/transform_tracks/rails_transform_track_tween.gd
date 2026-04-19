@tool
extends RailsTransformTrack
class_name RailsTransformTrackTween


@export var reverse_on_track_finished: bool = false
@export var duration: float = 5.0
var direction: int = 1

var _tween: Tween

func _handle_track_finished() -> void:
	if reverse_on_track_finished:
		direction *= -1
	super()


func is_running() -> bool:
	return _tween.is_running() if _tween else false


func start(node: Node2D, base_transform: Transform2D = Transform2D.IDENTITY) -> void:
	super(node, base_transform)
	if _tween:
		_tween.kill()
	_tween = create_tween()
	prepare_tween(_tween)
	_tween.finished.connect(
		func():
			track_finished.emit()
	)


func prepare_tween(tween: Tween) -> Tween:
	return tween


func stop() -> void:
	super()
	direction = 1
	if _tween:
		_tween.kill()
	
