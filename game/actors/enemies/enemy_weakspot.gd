extends Node2D
class_name EnemyWeakspot
@onready var damagable: Damagable = $Body/Damagable
@onready var collision_polygon_2d: CollisionPolygon2D = $Body/CollisionPolygon2D


func _ready() -> void:
	damagable.on_death.connect(die)


func die(_actor: Node2D) -> void:
	disable_collisions()


func disable_collisions() -> void:
	collision_polygon_2d.set_deferred("disabled", true)
	queue_free()
