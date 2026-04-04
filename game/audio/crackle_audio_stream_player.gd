extends ExtendedAudioStreamPlayer
class_name CrackleAudioStreamPlayer

@export var crackling: bool = false : set = _set_crackling
@export_range(0., 100., .01, "or_greater") var crackle_time: float = 5.0
@export var channel_count: int = 1 : set = _set_channel_count
## How much of the stream length should odd channels be offset
@export_range(0., 1.0, .05) var odd_channel_offset: float = .5
## 
@export_range(0., 10.0, .01, "or_greater") var cooldown: float = 1.0
@export_range(0., 10.0, .01, "or_greater") var cooldown_max_delta: float = 1.0

var audio_players: Array[ExtendedAudioStreamPlayer] = []
var cooldowns: Array[float]
var remaining_crackle_time: float = 0.0

## Playing the first sound plays it instantly
## odd channels will have a random delay applied
## even channels will have the even channel offset 
## plus variance


func _ready() -> void:
	_reset_channels()


func _physics_process(delta: float) -> void:
	_update_timers(delta)
	if remaining_crackle_time <= 0.0 and crackling:
		crackling = false
	for i in range(cooldowns.size()):
		if cooldowns[i] <= 0. and crackling:
			play_channel(i)


func _update_timers(delta: float) -> void:
	if remaining_crackle_time > 0.0:
		remaining_crackle_time -= delta
	for i in range(cooldowns.size()):
		if audio_players.size() > i:
			var audio_player := audio_players[i]
			if !audio_player.playing and cooldowns[i] > 0.:
				cooldowns[i] -= delta


func start_crackling() -> void:
	crackling = true


func _start_crackling() -> void:
	stop_all_channels()
	cooldowns = []
	play_channel(0)
	for i in range(channel_count):
		if i % 2 == 0:
			cooldowns.append(_get_new_cooldown())
		else:
			cooldowns.append(_get_new_offset())
	remaining_crackle_time = crackle_time


func stop_crackling() -> void:
	crackling = false


func _stop_crackling() -> void:
	remaining_crackle_time = 0.0
	cooldowns = []


func play_channel(i: int) -> bool:
	if i < 0: return false
	var audio_player := audio_players[i] if audio_players.size() > i else null
	if audio_player == null or !audio_player is AudioStreamPlayer:
		return false
	if audio_player is ExtendedAudioStreamPlayer:
		audio_player.play_at_random_pitch()
	elif audio_player is AudioStreamPlayer:
		audio_player.play()
	if cooldowns.size() > i:
		cooldowns[i] = _get_new_cooldown()
	return true
	

func stop_all_channels() -> void:
	for audio_player in audio_players:
		if audio_player.playing:
			audio_player.stop()


func _get_new_cooldown() -> float:
	return cooldown + randf_range(-cooldown_max_delta, cooldown_max_delta)


func _get_new_offset() -> float:
	return (stream.get_length() * odd_channel_offset) + randf_range(-cooldown_max_delta, cooldown_max_delta)


func _reset_channels() -> void:
	if playing:
		stop()
	for child in get_children():
		if child is AudioStreamPlayer:
			if child.playing:
				child.stop()
		child.queue_free()
	audio_players = [self]
	for i in range(channel_count - 1):
		var new_channel := make_channel()
		add_child(new_channel)
		audio_players.append(new_channel)


func make_channel() -> ExtendedAudioStreamPlayer:
	var new_channel := ExtendedAudioStreamPlayer.new()
	new_channel.stream = stream
	new_channel.volume_db = volume_db
	new_channel.pitch_jitter = pitch_jitter
	new_channel.pitch_scale = pitch_scale
	return new_channel


func _set_crackling(value: bool) -> void:
	if !crackling and value:
		_start_crackling()
	if crackling and !value:
		_stop_crackling()
	crackling = value


func _set_channel_count(value: int) -> void:
	_reset_channels()
	channel_count = value
