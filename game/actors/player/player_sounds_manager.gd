extends Node
class_name PlayerSoundsManager


@onready var thruster_audio_stream_player: ExtendedAudioStreamPlayer = $ThrusterAudioStreamPlayer
@onready var fire_players: Node = $FirePlayers
@onready var metal_players: Node = $CollisionPlayers/MetalPlayers

@export var player_move_machine: PlayerMoveMachine
@export var collision_cooldown_max: float = .05
@export var metal_collision_cooldown: float = 0.0
@export var collision_volumn_curve: Curve

var thruster_tween: Tween


func _physics_process(delta: float) -> void:
	_thruster(delta)
	_process_timers(delta)


func _process_timers(delta: float) -> void:
	if metal_collision_cooldown >= 0.0:
		metal_collision_cooldown -= delta


func _thruster(_delta: float) -> void:
	if player_move_machine:
		if player_move_machine.state == PlayerMoveMachine.State.IDLE:
			if thruster_audio_stream_player.playing and thruster_audio_stream_player.fade_direction != -1:
				thruster_audio_stream_player.fade_out()
		else:
			if !thruster_audio_stream_player.playing or thruster_audio_stream_player.fade_direction == -1:
				thruster_audio_stream_player.fade_in()

func fire() -> void:
	for child in fire_players.get_children():
		if child is ExtendedAudioStreamPlayer:
			if !child.playing:
				child.play_at_random_pitch()
				return
	print('can not play fire sound')


func handle_collision(collider: Object, strength: float) -> void:
	var actor_type = GameActor.get_actor_type(collider)
	var actor_material = GameActor.get_actor_material(collider)
	match(actor_material):
		GameActor.ActorMaterial.UNKNOWN, GameActor.ActorMaterial.METAL:
			_handle_metal_collision(strength)
		GameActor.ActorMaterial.ENERGY:
			_handle_metal_collision(collision_volumn_curve.max_domain / 2.)


func _handle_metal_collision(strength: float) -> void:
	if metal_collision_cooldown > 0.0:
		return
	for child in metal_players.get_children():
		if child is ExtendedAudioStreamPlayer:
			if !child.playing:
				if collision_volumn_curve:
					var collision_volumn_db := collision_volumn_curve.sample(
						clamp(strength, collision_volumn_curve.min_domain, collision_volumn_curve.max_domain)
					)
					child.volume_db = collision_volumn_db
				child.play_at_random_pitch()
				metal_collision_cooldown = collision_cooldown_max
				return
