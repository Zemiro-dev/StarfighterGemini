extends CharacterBody2D
class_name Player

@onready var controller: PlayerController = $Controller
@onready var physics_body_move_resolver: PhysicsBodyMoveResolver = $PhysicsBodyMoveResolver
@onready var steering: Steering = $Steering
@onready var move_machine: PlayerMoveMachine = $Machines/PlayerMoveMachine
@onready var blast_pool: NodePool = NodePool.new()
@onready var damagable: Damagable = $Damagable
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var body_sprite: Sprite2D = $ShipPieces/BodySprite
@onready var player_damaged_tween: PlayerDamagedTween = $PlayerDamagedTween
@onready var sounds_manager: PlayerSoundsManager = $SoundsManager
@onready var player_explosion: GPUParticles2D = $PlayerExplosionA

@export var blast_pack: PackedScene = preload("res://actors/projectiles/projectile_blue_blast.tscn")

var actor_type := GameActor.ActorType.PLAYER

func _ready() -> void:
	move_machine.actor = self
	move_machine.on_state_change.connect(on_move_state_change)
	damagable.on_death.connect(die)
	$ShipPieces/TopCannon.controller = controller
	$ShipPieces/BottomCannon.controller = controller
	blast_pool.spawn_signal = GlobalSignals.request_projectile_spawn
	blast_pool.fill(blast_pack, 20)
	player_damaged_tween.node = self
	remove_child(player_explosion)
	GlobalSignals.world_ready.connect(func(): GlobalSignals.request_top_effect_spawn.emit(player_explosion))
	physics_body_move_resolver.collided_with.connect(sounds_manager.handle_collision)


func _physics_process(delta: float) -> void:
	velocity = physics_body_move_resolver.resolve(move_machine.process(delta), delta)

	if Input.is_action_pressed("fire"):
		fire()
	if Input.is_action_just_pressed("dev_a"):
		controller.is_goal_locked = !controller.is_goal_locked


func on_move_state_change(prev:PlayerMoveMachine.State,  next: PlayerMoveMachine.State): 
	if next == PlayerMoveMachine.State.DASH:
		controller.is_goal_locked = true
	else:
		controller.is_goal_locked = false


func fire() -> void:
	var attacks := []
	attacks.append($ShipPieces/TopCannon.fire(blast_pool))
	attacks.append($ShipPieces/BottomCannon.fire(blast_pool))
	if attacks.any(func(value): return value):
		sounds_manager.fire()


func die(actor: Node2D) -> void:
	controller.controllable = false
	if animation_player.is_playing():
		animation_player.stop()
	animation_player.play('die')


func set_is_explosion_emitting(value: bool) -> void:
	player_explosion.emitting = value


func disable_collisions() -> void:
	collision_shape_2d.set_deferred("disabled", true)


func enable_collisions() -> void:
	collision_shape_2d.set_deferred("disabled", false)


func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		if player_explosion:
			player_explosion.queue_free()
