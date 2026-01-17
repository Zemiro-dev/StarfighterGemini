@tool
extends Node2D

@onready var starfield_1: TextureRect = $Stage/Starfield1
@onready var noise_mixer: TextureRect = $Stage/Nebula/NoiseMixer
@export var scroll_velocity := Vector2(.001, 0)
var scroll := Vector2.ZERO
@export var mix_ratio : float = 1.0
func _physics_process(delta: float) -> void:
	scroll += scroll_velocity * delta
	starfield_1.material.set("shader_parameter/offset", scroll)
	noise_mixer.material.set("shader_parameter/mix_ratio", mix_ratio)
