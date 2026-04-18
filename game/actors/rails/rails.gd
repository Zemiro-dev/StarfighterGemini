extends Object
class_name Rails

static func next_transform_from_track(
	track: Node,
	prevTransform: Transform2D = Transform2D.IDENTITY
) -> Transform2D:
	if track is RailsTransformTrack:
		match(track.combination_style):
			RailsTrack.TransformCombinationStyle.DEFAULT:
				return prevTransform * track.sample()
			RailsTrack.TransformCombinationStyle.TRANSLATE_ONLY:
				var t = track.sample()
				return prevTransform.translated(t.origin)
	return prevTransform
