@tool
extends Node2D
class_name EnemyDamagingSegment
@onready var damagable: Damagable = $Body/Damagable
@onready var collision_polygon_2d: CollisionPolygon2D = $Body/CollisionPolygon2D

var actor_type := GameActor.ActorType.ENEMY


func _ready() -> void:
	damagable.on_death.connect(die)
	

func attack(target: Object) -> int:
	return GameActor.attack(target, 1)


func die(actor: Node2D) -> void:
	disable_collisions()


func disable_collisions() -> void:
	collision_polygon_2d.set_deferred("disabled", true)
	queue_free()
