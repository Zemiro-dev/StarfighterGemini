extends Node2D

@onready var player_animation_player: AnimationPlayer = $Stage/Actors/Player/PlayerAnimationPlayer

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed('demo'):
		player_animation_player.stop()
		player_animation_player.play('fire');
