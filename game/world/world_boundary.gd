extends StaticBody2D
class_name WorldBoundary

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var actor_type := GameActor.ActorType.BOUNDARY
var actor_material := GameActor.ActorMaterial.BOUNDARY
