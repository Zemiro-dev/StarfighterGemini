extends Node
class_name PhysicsBodyMoveResolver

class MoveRequest extends Resource:
	var body: PhysicsBody2D
	var velocity: Vector2 = Vector2.ZERO
	var steering: Steering
	var should_slow: bool = false


func resolve(request: MoveRequest, delta: float) -> Vector2:
	var velocity := request.velocity
	var steering := request.steering
	var body :=	 request.body
	if steering:
		if !request.should_slow:
			velocity = steering.steer(velocity, delta)
		else:
			velocity = steering.slow(velocity, delta)
	
	var collision: KinematicCollision2D = body.move_and_collide(velocity * delta)
	if collision:
			var collider: Object = collision.get_collider()
			var depth := collision.get_depth()
			var remainder := collision.get_remainder()
			var collider_type = GameActor.get_actor_type(collider)
			var normal = collision.get_normal()
			## Base Movement Effects
			match (collider_type):
				GameActor.ActorType.UNKNOWN, GameActor.ActorType.TERRAIN, GameActor.ActorType.ENEMY, GameActor.ActorType.DESTRUCTIBLE:
					var nvdot := normal.dot(velocity.normalized())
					if nvdot <= 0.:
						velocity = velocity.bounce(normal)
			
			## Damage and Additional Knockback 
			match (collider_type):
				GameActor.ActorType.ENEMY:
					if GameActor.check_and_attack(collider, request.body) >= 0:
						velocity += velocity.normalized() * 600.
	if steering and steering.should_overspeed_break(velocity):
		velocity = steering.overspeed_break(velocity, delta)
	return velocity
