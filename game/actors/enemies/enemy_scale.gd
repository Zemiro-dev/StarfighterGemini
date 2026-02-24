extends AnimatableBody2D
class_name EnemyScale

@onready var collision_polygon_2d: CollisionPolygon2D
@export var sprite_2d: Sprite2D


func _ready() -> void:
	if (!collision_polygon_2d):
		var children := get_children()
		var child_index := children.find_custom(
			func(child: Node): 
				return child is CollisionPolygon2D
		)
		if child_index >= 0:
			collision_polygon_2d = children[child_index]
		
	if !sprite_2d:
		var children := get_children()
		var child_index := children.find_custom(
			func(child: Node): 
				return child is Sprite2D
		)
		if child_index >= 0:
			sprite_2d = children[child_index]
