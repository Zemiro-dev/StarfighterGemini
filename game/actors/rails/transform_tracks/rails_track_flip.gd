@tool
extends RailsTransformTrack
class_name RailsTrackFlip

@export var flip_x := false
@export var flip_y := false
var movement_transform := Transform2D.IDENTITY
var _is_running := false

func _ready() -> void:
	super()
	finished.connect(func(): _is_running = false)
	if combination_style == RailsTrack.TransformCombinationStyle.DEFAULT:
		combination_style = RailsTrack.TransformCombinationStyle.FLIP


func _physics_process(delta: float) -> void:
	if _is_running:
		track_finished.emit()


func sample() -> Transform2D:
	return movement_transform



func start(node: Node2D, base_transform: Transform2D = Transform2D.IDENTITY) -> void:
	super(node, base_transform)
	movement_transform = Transform2D.IDENTITY
	if flip_x:
		movement_transform *= Transform2D.FLIP_X
	if flip_y:
		movement_transform *= Transform2D.FLIP_Y
	_is_running = true


func reset() -> void:
	super()
	movement_transform = Transform2D.IDENTITY
	_is_running = false


func is_running() -> bool:
	return _is_running
