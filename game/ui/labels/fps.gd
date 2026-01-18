@tool
extends Label

func _physics_process(delta: float) -> void:
	text = 'FPS: %s' % Engine.get_frames_per_second()
