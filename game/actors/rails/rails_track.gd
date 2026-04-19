@tool
extends Node
class_name RailsTrack

## Called when an individual track is finished
signal track_finished()
## Called when the track is no longer running
signal finished()

enum TransformCombinationStyle { DEFAULT, MULT, TRANSLATE_ONLY, ROTATE_ONLY}


@export var is_one_shot := true
@export var _node: Node2D
var _base_transform: Transform2D
@export var combination_style: TransformCombinationStyle = TransformCombinationStyle.DEFAULT


func _ready() -> void:
	stop()
	track_finished.connect(_handle_track_finished)


func _handle_track_finished() -> void:
	if !is_one_shot:
		start(_node)
	else:
		finished.emit()


func start(node: Node2D, base_transform: Transform2D = Transform2D.IDENTITY) -> void:
	_node = node
	_base_transform = base_transform


func stop() -> void:
	reset()


func reset() -> void:
	_node = null
	_base_transform = Transform2D.IDENTITY
	


func is_running() -> bool:
	return false
