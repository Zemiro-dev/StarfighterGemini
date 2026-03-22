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
	$ShipPieces/TopCannon.fire(blast_pool)
	$ShipPieces/BottomCannon.fire(blast_pool)


func die(actor: Node2D) -> void:
	animation_player.play('die')


func disable_collisions() -> void:
	collision_shape_2d.set_deferred("disabled", true)


func enable_collisions() -> void:
	collision_shape_2d.set_deferred("disabled", false)
