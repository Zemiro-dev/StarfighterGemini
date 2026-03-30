extends Node
class_name PlayerSoundsManager


@onready var thruster_audio_stream_player: ExtendedAudioStreamPlayer = $ThrusterAudioStreamPlayer
@onready var fire_players: Node = $FirePlayers

@export var player_move_machine: PlayerMoveMachine
@export var pitch_jitter: float = 0.1

var thruster_tween: Tween


func _physics_process(delta: float) -> void:
	_thruster(delta)


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
