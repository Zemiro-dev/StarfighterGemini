extends RailsContainerTrack
class_name RailsSequenceTrack


var tracks: Array[RailsTrack] = []
var current_track_index: int = 0
var _is_running: bool = false
var _xform: Transform2D


func _ready() -> void:
	super()
	finished.connect(func(): _is_running = false)

func sample() -> Transform2D:
	var xform = Transform2D()
	for track in tracks:
		if track is RailsTransformTrack:
			xform *= track.sample()
	return _xform * xform


func start(node: Node2D) -> void:
	super(node)
	_is_running = true
	if tracks.is_empty():
		for child in get_children():
			if child is RailsTrack:
				tracks.append(child)
	_start_current_track()


func stop() -> void:
	for track in tracks:
		track.stop()
	tracks = []
	_is_running = false
	super()


func reset() -> void:
	super()
	current_track_index = 0
	_xform = Transform2D()


func is_running() -> bool:
	return _is_running


func _start_current_track() -> void:
	current_track_index = ((current_track_index % tracks.size()) + tracks.size()) % tracks.size()
	var track := tracks[current_track_index]
	track.start(_node)
	track.finished.connect(_handle_current_track_finished)


func _handle_current_track_finished() -> void:
	var track := tracks[current_track_index]
	if track.finished.is_connected(_handle_current_track_finished):
		track.finished.disconnect(_handle_current_track_finished)
	current_track_index += 1
	if current_track_index == tracks.size():
		track_finished.emit()
	else:
		_start_current_track()


func _handle_track_finished() -> void:
	_xform = sample()
	for track in tracks:
		track.reset()
	super()
