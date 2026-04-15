extends Node
class_name RailsConductor

@export var node: Node2D
var base_transform: Transform2D


func _ready() -> void:
	if node:
		reset()


func _physics_process(_delta: float) -> void:
	if node:
		var frame_transform = Transform2D(base_transform)
		for child in get_children():
			frame_transform = Rails.next_transform_from_track(child, frame_transform)
		node.transform = frame_transform


func start(track_name: String) -> RailsTrack:
	if has_node(track_name):
		var child := get_node(track_name)
		if child is RailsTrack:
			child.start(node, base_transform)
			return child
	return null


func drive(node_to_drive: Node2D) -> void:
	node = node_to_drive
	reset()


func reset() -> void:
	if !node: return
	_reset_base_trasform()
	for child in get_children():
		if child is RailsTrack:
			child.stop()
			#child.start(node, base_transform)


func _reset_base_trasform() -> void:
	if node:
		base_transform = node.transform
