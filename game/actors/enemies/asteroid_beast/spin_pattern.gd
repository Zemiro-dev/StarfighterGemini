@tool
extends Node2D
class_name SpinPattern

@export var toy: Node2D: set = _set_toy
@export var is_spinning: bool: set = _set_is_spinning

var spin_tween: Tween


func _ready() -> void:
	is_spinning = true


func start_spinning() -> void:
	if spin_tween:
		spin_tween.kill()
	if !toy: return
	spin_tween = toy.create_tween()
	spin_tween.set_loops()
	spin_tween.tween_property(toy, 'rotation', -TAU, 3).as_relative().set_trans(Tween.TRANS_SINE)


func stop_spinning() -> void:
	if spin_tween:
		spin_tween.kill()

func _set_toy(new_toy: Node2D) -> void:
	toy = new_toy


func _set_is_spinning(_is_spinning: bool) -> void:
	if !is_spinning and _is_spinning:
		start_spinning()
	if is_spinning and !_is_spinning:
		stop_spinning()
	is_spinning = _is_spinning

## Script Template
#@tool
#extends Node2D
#class_name ToyPatternPin
#
#@onready var remote_transform_2d: RemoteTransform2D = $RemoteTransform2D
#@export var toy: Node2D: set = _set_toy
#
#
#func _set_toy(new_toy: Node2D) -> void:
	#toy = new_toy
	#if toy:
		#global_position = toy.global_position
		#remote_transform_2d.position = Vector2.ZERO
		#remote_transform_2d.remote_path = toy.get_path()
	#else:
		#remote_transform_2d.remote_path = ''
