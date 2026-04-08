extends Area2D
class_name Projectile

@onready var lifetime: Timer = $Lifetime
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var is_available := true: set = set_is_available
@export var stats: ProjectileStats
@export var explosion_scene: PackedScene = preload("res://actors/player/player_explosion_b.tscn")
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var explosion_audio_stream_player: ExtendedAudioStreamPlayer = $ExplosionAudioStreamPlayer

var velocity := Vector2.ZERO
var live := false
var explosion: GPUParticles2D


func _ready() -> void:
	if !stats: stats = ProjectileStats.new()
	body_entered.connect(on_body_entered)
	lifetime.timeout.connect(off)
	off() # start off
	var explosion_instance = explosion_scene.instantiate()
	if explosion_instance is GPUParticles2D:
		explosion = explosion_instance


func on_body_entered(body: Node2D) -> void:
	if live:
		var damage_dealt = GameActor.attack(body, stats.damage)
		if explosion:
			explosion.global_transform = global_transform
			explosion.reset_physics_interpolation()
			explosion.emitting = true
			if !explosion_audio_stream_player.playing:
				explosion_audio_stream_player.play_at_random_pitch()
		off()


func set_is_available(new_value: bool):
	is_available = new_value
	if !is_available:
		process_mode = Node.PROCESS_MODE_INHERIT
	else:
		process_mode = Node.PROCESS_MODE_DISABLED


func fire(_transform: Transform2D) -> void:
	global_transform = _transform
	on()
	velocity = Vector2.from_angle(rotation) * stats.muzzle_speed
	reset_physics_interpolation()


func on() -> void:
	live = true
	velocity = Vector2.ZERO
	collision_shape_2d.set_deferred('disabled', false)
	animation_player.play("on")
	lifetime.start()
	if explosion:
		if explosion.emitting:
			explosion.emitting = false
		if !explosion.is_inside_tree():
			GlobalSignals.request_top_effect_spawn.emit(explosion)
		
	

func off() -> void:
	live = false
	velocity = Vector2.ZERO
	collision_shape_2d.set_deferred('disabled', true)
	animation_player.play("off")


func _physics_process(delta: float) -> void:
	if !velocity.is_zero_approx():
		rotation = velocity.angle()
		var space_state := get_world_2d().direct_space_state
		var query := PhysicsShapeQueryParameters2D.new()
		query.shape = collision_shape_2d.shape
		query.transform = global_transform
		query.collide_with_areas = false
		query.collide_with_bodies = true
		query.collision_mask = collision_mask
		query.motion = velocity * delta
		var result = space_state.cast_motion(query)
		var unsafe = result[1]
		if unsafe >= 1.0:
			global_position += velocity * delta
		else:
			global_position += velocity * delta * unsafe


func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		if explosion:
			explosion.queue_free()
