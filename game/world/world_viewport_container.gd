extends SubViewportContainer
class_name WorldViewportContainer

@onready var world_viewport: SubViewport = $WorldViewport

@export var start_up_path := "res://world/debug/world_changer.tscn"

func _ready() -> void:
	GlobalSignals.request_main_scene_change.connect(_handle_scene_change)
	GlobalSignals.request_main_scene_change.emit(start_up_path)


func _handle_scene_change(scene_path: String):
	var scene = await load(scene_path).instantiate()
	if scene is Node2D:
		for child in world_viewport.get_children():
			child.queue_free()
		scene.position = Vector2(
			abs(position.x),
			abs(position.y)
		)
		world_viewport.add_child(scene)
