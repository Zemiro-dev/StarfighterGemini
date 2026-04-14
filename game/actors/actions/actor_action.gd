extends Node
class_name ActorAction

@export var is_one_shot := true
## The transform to apply to the Actor that defines the action
## Will be applied to the actor each physics frame
var action_transform: Transform2D


func _ready() -> void:
	reset()


func act(_delta: float) -> void:
	pass


func run() -> void:
	pass


func is_running() -> bool:
	return true


func reset() -> void:
	action_transform = Transform2D()
