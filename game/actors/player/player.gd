extends CharacterBody2D
class_name Player

@onready var controller: PlayerController = $Controller
@onready var physics_body_move_resolver: PhysicsBodyMoveResolver = $PhysicsBodyMoveResolver
@onready var steering: Steering = $Steering
@onready var move_request: PhysicsBodyMoveResolver.MoveRequest

func _ready() -> void:
	move_request = PhysicsBodyMoveResolver.MoveRequest.new()
	move_request.body = self
	move_request.steering = steering;
	

func _physics_process(delta: float) -> void:
	move_request.velocity = velocity
	move_request.should_slow = controller.get_goal().is_zero_approx()
	velocity = physics_body_move_resolver.resolve(move_request, delta)
