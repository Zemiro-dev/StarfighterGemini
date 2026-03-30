extends AudioStreamPlayer
class_name ExtendedAudioStreamPlayer
 
@export var pitch_jitter: float = 0.05
@onready var original_pitch: float = pitch_scale
@onready var original_volume_db: float = volume_db
@onready var min_volumn_db: float = -60.0
@export var fade_time: float = .3

var _fade_tween: Tween
var fade_direction: int = 0

func play_at_random_pitch() -> void:
	var new_pitch: float = original_pitch + [-pitch_jitter, 0, pitch_jitter].pick_random()
	pitch_scale = new_pitch
	play()


func fade_in() -> void:
	if _fade_tween:
		_fade_tween.kill()
	
	if volume_db >= original_volume_db:
		volume_db = min_volumn_db
	
	_fade_tween = create_tween()
	fade_direction = 1
	
	var remaining_fade_time = (1. - inverse_lerp(min_volumn_db, original_volume_db, volume_db)) * fade_time
	_fade_tween.tween_property(self, "volume_db", original_volume_db, remaining_fade_time)
	_fade_tween.finished.connect(func(): fade_direction = 0)
	
	if !playing:
		play_at_random_pitch()


func fade_out() -> void:
	if !playing:
		return

	if _fade_tween:
		_fade_tween.kill()
	
	_fade_tween = create_tween()
	fade_direction = -1
	var remaining_fade_time = (1. - inverse_lerp(original_volume_db, min_volumn_db, volume_db)) * fade_time
	_fade_tween.tween_property(self, "volume_db", min_volumn_db, remaining_fade_time)
	_fade_tween.finished.connect(func(): stop())
	_fade_tween.finished.connect(func(): fade_direction = 0)
