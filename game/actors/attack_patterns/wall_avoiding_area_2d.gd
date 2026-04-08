extends Area2D
class_name WallAvoidingArea2D


@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _physics_process(delta: float) -> void:
	print(position)
	print(global_position)
	position = Vector2.ZERO
	for body in get_overlapping_bodies():
		var actor_type := GameActor.get_actor_type(body)
		if actor_type == GameActor.ActorType.BOUNDARY:
			seperate_from_boundary(body)


func seperate_from_boundary(body: Node2D) -> void:
	if body is WorldBoundary:
		var my_shape: Shape2D = collision_shape_2d.shape
		var boundary_shape: Shape2D = body.collision_shape_2d.shape
		if !my_shape or !boundary_shape: return
		var my_xform: Transform2D = collision_shape_2d.global_transform
		var boundary_xform: Transform2D = body.collision_shape_2d.global_transform
		var collision_points := my_shape.collide_and_get_contacts(my_xform, boundary_shape, boundary_xform)
		if collision_points.size() < 2: return
		var a := collision_points[0]
		var b := collision_points[1]
		var depth = b - a
		position += depth
