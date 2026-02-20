extends CharacterBody2D
class_name Player

@onready var controller: PlayerController = $Controller
@onready var physics_body_move_resolver: PhysicsBodyMoveResolver = $PhysicsBodyMoveResolver
@onready var steering: Steering = $Steering
@onready var move_machine: PlayerMoveMachine = $Machines/PlayerMoveMachine

func _ready() -> void:
	move_machine.actor = self

func _physics_process(delta: float) -> void:
	velocity = physics_body_move_resolver.resolve(move_machine.process(delta), delta)
