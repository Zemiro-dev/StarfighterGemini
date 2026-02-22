extends Node
class_name PlayerMoveMachine

enum State {IDLE, STANDARD, DASH}

signal on_state_change(prev: State, current: State)

@export var state := State.IDLE: set = _set_state
@export var actor: Player: set = _set_actor
@onready var move_request: PhysicsBodyMoveResolver.MoveRequest = PhysicsBodyMoveResolver.MoveRequest.new()

var remaining_dash_time := 0.0
var remaining_dash_cooldown := 0.0


func _ready() -> void:
	_set_state(state) # ensure code requiring ready is called


func _set_state(new_state: State) -> void:
## Exit State Handlers
	match (state):
		State.DASH:
			actor.steering.power_multiplier = 1.0
		
	match(new_state):
		State.DASH, State.STANDARD:
			move_request.should_slow = false

	match(new_state):
		State.DASH:
			actor.steering.power_multiplier = actor.steering.steering_stats.dash_multiplier
			remaining_dash_cooldown = actor.steering.steering_stats.dash_cooldown
			remaining_dash_time = actor.steering.steering_stats.dash_duration
		State.IDLE:
			move_request.should_slow = true

	var prev := state
	state = new_state
	on_state_change.emit(prev, state)


func _set_actor(new_actor: Player) -> void:
	actor = new_actor
	move_request.body = actor
	move_request.steering = actor.steering
	_set_state(state) # reset any actor values we're gonna manipulate


func process(delta: float) -> PhysicsBodyMoveResolver.MoveRequest:
	update_timers(delta)
	match (state):
		State.STANDARD:
			if should_dash():
				state = State.DASH
			elif actor.controller.get_goal().is_zero_approx():
				state = State.IDLE
		State.DASH:
			if remaining_dash_time <= 0.0:
				state = State.IDLE
		State.IDLE:
			if should_dash():
				state = State.DASH
			elif !actor.controller.get_goal().is_zero_approx():
				state = State.STANDARD
			

	move_request.velocity = actor.velocity
	return move_request


func update_timers(delta: float) -> void:
	if remaining_dash_cooldown >= 0.0: remaining_dash_cooldown -= delta
	if remaining_dash_time >= 0.0: remaining_dash_time -= delta


func should_dash() -> bool:
	if actor.controller.dash_pressed() and remaining_dash_cooldown <= 0.0:
		return true
	return false
