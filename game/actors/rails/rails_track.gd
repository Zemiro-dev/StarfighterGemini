@tool
extends Node
class_name RailsTrack

## Called when an individual track is finished
signal track_finished()
## Called when the track is no longer running
signal finished()

enum TransformCombinationStyle { DEFAULT, MULT, TRANSLATE_ONLY, ROTATE_ONLY, FLIP }


@export var is_one_shot := true
@export var _node: Node2D
@export var should_container_skip := false
@export var combination_style: TransformCombinationStyle = TransformCombinationStyle.DEFAULT
@onready var _base_transform: Transform2D = Transform2D.IDENTITY
@export_tool_button("Rerun", "Reload") var rerun_action := _handle_rerun

func _handle_rerun():
	var node = _node
	var base_transform = _base_transform
	stop()
	start(node, base_transform)



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
