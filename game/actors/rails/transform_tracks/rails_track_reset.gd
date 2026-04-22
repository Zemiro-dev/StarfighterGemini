@tool
extends RailsTransformTrack
class_name RailsTrackReset


@export var duration: float = 1.0
var xform_inverse: Transform2D
var movement_transform := Transform2D.IDENTITY
var progress := 0.0
var _is_running := false

var dnode


func _ready() -> void:
	super()
	finished.connect(func(): _is_running = false)


func _physics_process(delta: float) -> void:
	if is_running():
		progress = clampf(progress + delta / duration, 0.0, 1.0)
		movement_transform = Transform2D.IDENTITY.interpolate_with(xform_inverse, progress)
		if progress >= 1.0:
			movement_transform = xform_inverse
			track_finished.emit()


func sample() -> Transform2D:
	return movement_transform


func start(node: Node2D, base_transform: Transform2D = Transform2D.IDENTITY) -> void:
	super(node, base_transform)
	dnode = node
	xform_inverse = (base_transform.affine_inverse() * node.transform).affine_inverse()
	_is_running = true


func reset() -> void:
	super()
	movement_transform = Transform2D.IDENTITY
	progress = 0.0
	_is_running = false


func is_running() -> bool:
	return _is_running
