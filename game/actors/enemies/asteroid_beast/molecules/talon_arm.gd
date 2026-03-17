extends Node2D


func _physics_process(delta: float) -> void:
	position += Vector2(-50 * delta, 0)
	#print(rotation)
	pass
