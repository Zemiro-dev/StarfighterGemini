extends CharacterBody2D
class_name Player

@onready var controller: PlayerController = $Controller
@onready var physics_body_move_resolver: PhysicsBodyMoveResolver = $PhysicsBodyMoveResolver
@onready var steering: Steering = $Steering
@onready var move_machine: PlayerMoveMachine = $Machines/PlayerMoveMachine

func _ready() -> void:
	move_machine.actor = self
	move_machine.on_state_change.connect(on_move_state_change)

func _physics_process(delta: float) -> void:
	velocity = physics_body_move_resolver.resolve(move_machine.process(delta), delta)


func on_move_state_change(prev:PlayerMoveMachine.State,  next: PlayerMoveMachine.State): 
	if next == PlayerMoveMachine.State.DASH:
		controller.is_goal_locked = true
	else:
		controller.is_goal_locked = false
