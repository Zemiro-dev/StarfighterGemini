@tool
extends Object
class_name Rails

static func next_transform_from_track(
	track: Node,
	prevTransform: Transform2D = Transform2D.IDENTITY
) -> Transform2D:
	if track is RailsTransformTrack:
		var sample = track.sample()
		match(track.combination_style):
			RailsTrack.TransformCombinationStyle.DEFAULT, RailsTrack.TransformCombinationStyle.MULT:
				return prevTransform * sample
			RailsTrack.TransformCombinationStyle.TRANSLATE_ONLY:
				return prevTransform.translated(sample.origin)
			RailsTrack.TransformCombinationStyle.ROTATE_ONLY:
				return prevTransform.rotated(sample.get_rotation())
	return prevTransform
