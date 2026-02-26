extends AnimatableBody2D
class_name EnemyScale


@onready var damagable: Damagable = $Damagable
@onready var collision_polygon_2d: CollisionPolygon2D = $CollisionPolygon2D


func _ready() -> void:
	damagable.on_death.connect(die)


func die(actor: Node2D) -> void:
	disable_collisions()


func disable_collisions() -> void:
	collision_polygon_2d.set_deferred("disabled", true)
	queue_free()
