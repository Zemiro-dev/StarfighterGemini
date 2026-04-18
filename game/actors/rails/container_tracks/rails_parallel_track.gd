extends RailsContainerTrack
class_name RailsParallelTrack



var subtrack_finished : Array[bool] = []


func start(node: Node2D, base_transform: Transform2D = Transform2D.IDENTITY) -> void:
	super(node, base_transform)
	_default_initialize_tracks()
	_start_all_tracks()


func _start_all_tracks():
	subtrack_finished = []
	subtrack_finished.resize(tracks.size())
	for i in range(tracks.size()):
		var track := tracks[i]
		track.start(_node, _base_transform)
		track.finished.connect(
			func():
				_handle_subtrack_finished(i)
		)


func _handle_subtrack_finished(index: int) -> void:
	if subtrack_finished.size() > index:
		subtrack_finished[index] = true
		if subtrack_finished.all(func(f: bool): return f):
			track_finished.emit()
