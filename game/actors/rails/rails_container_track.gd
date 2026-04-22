@tool
extends RailsTransformTrack
class_name RailsContainerTrack


var tracks: Array[RailsTrack] = []
var _is_running: bool = false
var previous_loops_transform: Transform2D = Transform2D.IDENTITY


func _ready() -> void:
	super()
	finished.connect(func(): _is_running = false)


func sample() -> Transform2D:
	var xform = Transform2D()
	for track in tracks:
		xform = Rails.next_transform_from_track(track, xform)
	return previous_loops_transform * xform


func start(node: Node2D, base_transform: Transform2D = Transform2D.IDENTITY) -> void:
	super(node, base_transform)
	_is_running = true


func stop() -> void:
	for track in tracks:
		track.stop()
	tracks = []
	_is_running = false
	super()


func reset() -> void:
	super()
	previous_loops_transform = Transform2D.IDENTITY


## Default initialize for tracks where children
## are loaded in as tracks
func _default_initialize_tracks() -> void:
	if tracks.is_empty():
		for child in get_children():
			if child is RailsTrack:
				if !child.should_container_skip:
					tracks.append(child)


func is_running() -> bool:
	return _is_running


func _handle_track_finished() -> void:
	previous_loops_transform = sample()
	for track in tracks:
		track.reset()
	super()
