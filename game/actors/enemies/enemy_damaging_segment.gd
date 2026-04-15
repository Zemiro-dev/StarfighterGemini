@tool
extends Node2D
class_name EnemyDamagingSegment
@onready var damagable: Damagable = $Body/Damagable
@onready var collision_polygon_2d: CollisionPolygon2D = $Body/CollisionPolygon2D
var attack_particles_scene: PackedScene = preload("res://actors/effects/energy_explosion_c.tscn")

var actor_type := GameActor.ActorType.ENEMY
var attack_particles: GPUParticles2D
var actor_material := GameActor.ActorMaterial.ENERGY


func _ready() -> void:
	damagable.on_death.connect(die)
	if attack_particles_scene:
		var attack_particles_instance = attack_particles_scene.instantiate()
		if attack_particles_instance is GPUParticles2D:
			attack_particles = attack_particles_instance
	

func attack(target: Object, _position: Vector2) -> int:
	if attack_particles:
		if !attack_particles.is_inside_tree():
			GlobalSignals.request_top_effect_spawn.emit(attack_particles)
		attack_particles.global_position = _position
		attack_particles.reset_physics_interpolation()
		attack_particles.emitting = true
	return GameActor.attack(target, 1)


func die(_actor: Node2D) -> void:
	disable_collisions()


func disable_collisions() -> void:
	collision_polygon_2d.set_deferred("disabled", true)
	queue_free()


func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		if attack_particles:
			attack_particles.queue_free()
