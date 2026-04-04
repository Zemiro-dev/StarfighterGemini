@tool
extends Node
class_name Damagable

signal on_damage_taken(damage_dealt: int)
signal on_health_changed(new_health: int, max_health: int)
signal on_death(actor: Node2D)
signal on_invincibility_changed(is_invincible: bool)


@export var stats: DamagableStats = DamagableStats.new()
@export var is_dead := false
@export var is_invincible := false: set = _set_is_invincible
@export var actor: Node2D
@onready var health: float = stats.max_health


func _ready() -> void:
	if !actor and actor is Node2D:
		actor = get_parent()


func _set_is_invincible(new_value: bool):
	if is_invincible != new_value:
		is_invincible = new_value
		on_invincibility_changed.emit(is_invincible)


func _physics_process(delta: float) -> void:
	_update_timers(delta)


func _update_timers(_delta: float) -> void:
	pass


func take_damage(damage: int) -> int:
	if !can_take_damage() or damage <= 0: return 0
	var prev_health := health
	health = max(health - damage, 0)
	var damage_taken = prev_health - health
	on_damage_taken.emit(abs(damage_taken))
	on_health_changed.emit(health, stats.max_health)
	if actor and health <= 0:
		is_dead = true
		on_death.emit(actor)
	return damage_taken


func can_take_damage() -> bool:
	return !is_dead && !is_invincible
