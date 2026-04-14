extends Node
class_name ActionManager


@export var node: Node2D
var base_transform: Transform2D
var actions: Array[ActorAction] = []

func _ready() -> void:
	if node:
		reset()


func _physics_process(delta: float) -> void:
	if node:
		var frame_transform = Transform2D(base_transform)
		for child in get_children():
			if child is ActorAction:
				if !child.is_one_shot and !child.is_running():
					child.run()
				child.act(delta)
				frame_transform *= child.action_transform
		node.transform = frame_transform
	


func drive(node_to_drive: Node2D) -> void:
	node = node_to_drive
	reset()


func reset() -> void:
	if !node: return
	_reset_base_trasform()
	for child in get_children():
		if child is ActorAction:
			child.reset()
			child.run()


func _reset_base_trasform() -> void:
	if node:
		base_transform = node.transform
