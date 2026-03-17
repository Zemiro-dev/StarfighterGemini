@tool
extends AnimatableBody2D
class_name EnemyScale


@onready var damagable: Damagable = $Damagable
@onready var collision_polygon_2d: CollisionPolygon2D = $CollisionPolygon2D

@export var gradient_low: GradientTexture1D = preload("res://actors/enemies/resources/asteroid_beast_gradient_low.tres")
@export var gradient_high: GradientTexture1D = preload("res://actors/enemies/resources/asteroid_beast_gradient_high.tres")
@export var armored_gradient_low: GradientTexture1D = preload("res://actors/enemies/resources/asteroid_beast_armored_gradient_low.tres")
@export var armored_gradient_high: GradientTexture1D = preload("res://actors/enemies/resources/asteroid_beast_armored_gradient_high.tres")

func _ready() -> void:
	damagable.on_death.connect(die)
	
	var armored_invincible_check = func(is_invincible: bool):
		if is_invincible:
			to_armored()
		else:
			to_unarmored()
	armored_invincible_check.call(damagable.is_invincible)
	damagable.on_invincibility_changed.connect(armored_invincible_check)
	


func die(actor: Node2D) -> void:
	disable_collisions()


func disable_collisions() -> void:
	collision_polygon_2d.set_deferred("disabled", true)
	queue_free()


func to_armored() -> void:
	update_gradients(armored_gradient_low, armored_gradient_high)


func to_unarmored() -> void:
	update_gradients(gradient_low, gradient_high)


func update_gradients(low: GradientTexture1D, high: GradientTexture1D) -> void:
	if material is ShaderMaterial:
		material.set_shader_parameter("gradient_texture_low", low);
		material.set_shader_parameter("gradient_texture_high", high);

func _physics_process(delta: float) -> void:
	pass
