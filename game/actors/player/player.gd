extends CharacterBody2D
class_name Player

@onready var controller: PlayerController = $Controller
@onready var physics_body_move_resolver: PhysicsBodyMoveResolver = $PhysicsBodyMoveResolver
@onready var steering: Steering = $Steering
@onready var move_machine: PlayerMoveMachine = $Machines/PlayerMoveMachine
@onready var blast_pool: NodePool = NodePool.new()

@export var blast_pack: PackedScene = preload("res://actors/projectiles/projectile_blue_blast.tscn")

func _ready() -> void:
	move_machine.actor = self
	move_machine.on_state_change.connect(on_move_state_change)
	$TopCannon.controller = controller
	blast_pool.spawn_signal = GlobalSignals.request_projectile_spawn
	blast_pool.fill(blast_pack, 20)


func _physics_process(delta: float) -> void:
	velocity = physics_body_move_resolver.resolve(move_machine.process(delta), delta)
	if Input.is_action_pressed("fire"):
		fire()


func on_move_state_change(prev:PlayerMoveMachine.State,  next: PlayerMoveMachine.State): 
	if next == PlayerMoveMachine.State.DASH:
		controller.is_goal_locked = true
	else:
		controller.is_goal_locked = false


func fire():
	$TopCannon.fire(blast_pool)
