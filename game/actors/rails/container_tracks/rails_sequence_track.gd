@tool
extends RailsContainerTrack
class_name RailsSequenceTrack


var current_track_index: int = 0


func start(node: Node2D, base_transform: Transform2D = Transform2D.IDENTITY) -> void:
	super(node, base_transform)
	_default_initialize_tracks()
	_start_current_track()


func reset() -> void:
	super()
	current_track_index = 0


func _start_current_track() -> void:
	current_track_index = ((current_track_index % tracks.size()) + tracks.size()) % tracks.size()
	var track := tracks[current_track_index]
	track.start(_node, _base_transform)
	if !track.finished.is_connected(_handle_current_track_finished):
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
