@tool
extends AnimatableBody2D
class_name EnemyWeakspot
@onready var damagable: Damagable = $Damagable
@onready var collision_polygon_2d: CollisionPolygon2D = $CollisionPolygon2D
@onready var initial_position := position

func _ready() -> void:
	damagable.on_death.connect(die)


func die(actor: Node2D) -> void:
	disable_collisions()


func disable_collisions() -> void:
	collision_polygon_2d.set_deferred("disabled", true)
	queue_free()


func _physics_process(delta: float) -> void:
	position = initial_position
