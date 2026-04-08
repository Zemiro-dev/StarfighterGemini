extends Node
class_name PhysicsBodyMoveResolver

signal collided_with(collider: Object, strength: float)

const MAX_COLLISIONS = 5
var recent_knockbacks: Array[PhysicsBody2D] = []
var knockback_cooldown_max := 0.1
var knockback_cooldown_remaining := 0.0

class MoveRequest extends Resource:
	var body: PhysicsBody2D
	var velocity: Vector2 = Vector2.ZERO
	var steering: Steering
	var should_slow: bool = false
	
func resolve_collisions(delta: float, velocity: Vector2, body: PhysicsBody2D) -> Vector2:
	var motion := delta * velocity
	var next_velocity := velocity
	var has_been_attacked := false
	for i in range(MAX_COLLISIONS):
		var collision: KinematicCollision2D = body.move_and_collide(motion)
		if collision:
			var collider: Object = collision.get_collider()
			var depth := collision.get_depth()
			var remainder := collision.get_remainder()
			var collider_type = GameActor.get_actor_type(collider)
			var normal = collision.get_normal()
			
			## No matter what resolve overlap
			if !is_zero_approx(depth):
				body.global_position += depth * normal
			
			# Base Movement Effects
			match (collider_type):
				GameActor.ActorType.UNKNOWN, GameActor.ActorType.TERRAIN, GameActor.ActorType.ENEMY, GameActor.ActorType.DESTRUCTIBLE, GameActor.ActorType.BOUNDARY:
					motion = remainder.bounce(normal)
					next_velocity = next_velocity.bounce(normal)
					var collision_strength = (velocity - next_velocity).length()
					collided_with.emit(collider, collision_strength)
			### Damage and Additional Knockback 
			match (collider_type):
				GameActor.ActorType.ENEMY:
					if !has_been_attacked and GameActor.check_and_attack(collider, body, collision.get_position()) >= 0:
						if !recent_knockbacks.has(body):
							next_velocity += next_velocity.normalized() * 2000.
							recent_knockbacks.append(body)
							if knockback_cooldown_remaining <= 0.0:
								knockback_cooldown_remaining = knockback_cooldown_max
						has_been_attacked = true
		else:
			break;
	return next_velocity


func resolve(request: MoveRequest, delta: float) -> Vector2:
	var velocity := request.velocity
	var steering := request.steering
	if steering:
		if !request.should_slow:
			velocity = steering.steer(velocity, delta)
		else:
			velocity = steering.slow(velocity, delta)
	
	velocity = resolve_collisions(delta, velocity, request.body)
	if steering and steering.should_overspeed_break(velocity):
		velocity = steering.overspeed_break(velocity, delta)
	return velocity


func _physics_process(delta: float) -> void:
	if knockback_cooldown_remaining >= 0.0:
		knockback_cooldown_remaining -= delta
	if recent_knockbacks.size() > 0 and knockback_cooldown_remaining <= 0.0:
		recent_knockbacks = []
