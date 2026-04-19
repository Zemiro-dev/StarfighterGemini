@tool
extends RailsContainerTrack
class_name RailsParallelTrack


var subtrack_finished : Array[bool] = []
var subtrack_lambdas: Array[Callable] = []


func start(node: Node2D, base_transform: Transform2D = Transform2D.IDENTITY) -> void:
	super(node, base_transform)
	_default_initialize_tracks()
	_start_all_tracks()
	
func stop() -> void:
	for i in range(tracks.size()):
		var track := tracks[i]
		if i < subtrack_lambdas.size() and !subtrack_lambdas[i].is_null() and track.finished.is_connected(subtrack_lambdas[i]):
			track.finished.disconnect(subtrack_lambdas[i])
	super()


func _start_all_tracks():
	subtrack_finished = []
	subtrack_finished.resize(tracks.size())
	subtrack_lambdas.resize(tracks.size())
	for i in range(tracks.size()):
		var track := tracks[i]
		track.start(_node, _base_transform)
		if i >= subtrack_lambdas.size() or subtrack_lambdas[i].is_null() or !track.finished.is_connected(subtrack_lambdas[i]):
			var handle_finished: Callable = func(): _handle_subtrack_finished(i)
			track.finished.connect(handle_finished)
			subtrack_lambdas[i] = handle_finished


func _handle_subtrack_finished(index: int) -> void:
	if subtrack_finished.size() > index:
		subtrack_finished[index] = true
		if subtrack_finished.all(func(f: bool): return f):
			track_finished.emit()
