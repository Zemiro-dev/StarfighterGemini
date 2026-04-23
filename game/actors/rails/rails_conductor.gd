@tool
extends Node
class_name RailsConductor

@export var node: Node2D
@export var base_transform: Transform2D = Transform2D.IDENTITY
@export var is_running: bool = false

@export_tool_button("Reset Base Transform", "Reload") var reset_action := _reset_base_trasform


func _physics_process(_delta: float) -> void:
	if node and is_running:
		var frame_transform = Transform2D(base_transform)
		for child in get_children():
			frame_transform = Rails.next_transform_from_track(child, frame_transform)
		node.transform = frame_transform


func start(track_name: String) -> RailsTrack:
	if has_node(track_name):
		is_running = true
		var child := get_node(track_name)
		if child is RailsTrack:
			child.start(node, base_transform)
			return child
	return null


func stop() -> void:
	is_running = false
	for child in get_children():
		if child is RailsTrack:
			child.stop()
	if node:
		node.transform = base_transform


func _reset_base_trasform() -> void:
	if node:
		base_transform = node.transform
	else:
		base_transform = Transform2D.IDENTITY
