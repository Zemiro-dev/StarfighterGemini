extends Node

@warning_ignore_start("unused_signal")
signal request_camera_shake(duration: float, strength: float)
signal request_hitstop(hitstop_time_ms: float)

signal request_projectile_spawn(projectile: Node2D)
signal request_top_effect_spawn(effect: Node2D)

signal world_ready()

signal request_collectible_spawn(position: Vector2, scene: PackedScene)
signal request_sound_spawn(sound: AudioStreamPlayer2D)
signal request_world_sound_spawn(source: Node2D, sound_scene: PackedScene)
signal request_play_sound_at(position: Vector2, stream: AudioStream, volumn_db: float)
signal request_enemy_spawn(enemy: Node)
signal request_game_win()
signal request_main_scene_change(scene_path: String)
#signal on_actor_damaged(body: Node2D, damagable: BaseDamagable)
@warning_ignore_restore("unused_signal")
