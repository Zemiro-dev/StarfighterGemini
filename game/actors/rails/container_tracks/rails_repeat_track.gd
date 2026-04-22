@tool
extends RailsContainerTrack
class_name RailsRepeatTrack



@export var repeat_count: int = 1
var current_play_count: int = 0


func start(node: Node2D, base_transform: Transform2D = Transform2D.IDENTITY) -> void:
	if !is_running():
		super(node, base_transform)
		_initialize_tracks()
		_play_subtrack()


func _initialize_tracks() -> void:
	if tracks.is_empty():
		for child in get_children():
			if child is RailsTrack:
				tracks.append(child)
				return ## We only care about having 1 child ever



func reset() -> void:
	super()
	current_play_count = 0


func _play_subtrack() -> void:
	if current_play_count < repeat_count and tracks.size() > 0:
		current_play_count += 1
		var track = tracks[0]
		track.start(_node, _base_transform)
		if !track.finished.is_connected(_handle_subtrack_finished):
			track.finished.connect(_handle_subtrack_finished)
	else:
		finished.emit()


func _handle_subtrack_finished() -> void:
	if current_play_count < repeat_count:
		_play_subtrack()
	else:
		track_finished.emit()


#func _start_current_track() -> void:
	#current_track_index = ((current_track_index % tracks.size()) + tracks.size()) % tracks.size()
	#var track := tracks[current_track_index]
	#track.start(_node, _base_transform)
	#track.finished.connect(_handle_current_track_finished)
#
#
#func _handle_current_track_finished() -> void:
	#var track := tracks[current_track_index]
	#if track.finished.is_connected(_handle_current_track_finished):
		#track.finished.disconnect(_handle_current_track_finished)
	#current_track_index += 1
	#if current_track_index == tracks.size():
		#track_finished.emit()
	#else:
		#_start_current_track()
