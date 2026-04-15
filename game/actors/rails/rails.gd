extends Object
class_name Rails

static func next_transform_from_track(
	track: Node,
	prevTransform: Transform2D = Transform2D.IDENTITY
) -> Transform2D:
	if track is RailsTransformTrack:
		return prevTransform * track.sample()
	return prevTransform
