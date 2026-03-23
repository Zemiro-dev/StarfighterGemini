extends Node
class_name PlayerDamagedTween

var node: Player: set = set_node
@export var damage_progress: float = .6
var _inital_progress: float = .15
var _tween: Tween


func set_node(new_node: Player):
	_inital_progress = .15
	if node:
		var damagable := GameActor.get_damagable(node)
		if damagable:
			var on_damage_taken = damagable.get('on_damage_taken')
			if on_damage_taken:
				if on_damage_taken is Signal:
					on_damage_taken.disconnect(_handle_damage)
	node = new_node
	if node:
		_inital_progress = node.body_sprite.material.get_shader_parameter('progress')
		var damagable := GameActor.get_damagable(node)
		if damagable:
			var on_damage_taken = damagable.get('on_damage_taken')
			if on_damage_taken:
				if on_damage_taken is Signal:
					on_damage_taken.connect(_handle_damage)


func _handle_damage(_dmg: int):
	tween(node, .1)


func tween(node: Player, duration: float):
	if _tween != null:
		_tween.kill()
	
	_tween = node.create_tween()
	var current_progress = node.body_sprite.material.get_shader_parameter('progress')
	_tween.tween_method(
		func(value): node.body_sprite.material.set_shader_parameter('progress', value),
		current_progress,
		damage_progress,
		duration / 4.
	)
	_tween.tween_method(
		func(value): node.body_sprite.material.set_shader_parameter('progress', value),
		damage_progress,
		_inital_progress,
		duration / 4.
	)
	_tween.tween_method(
		func(value): node.body_sprite.material.set_shader_parameter('progress', value),
		current_progress,
		damage_progress,
		duration / 4.
	)
	_tween.tween_method(
		func(value): node.body_sprite.material.set_shader_parameter('progress', value),
		damage_progress,
		_inital_progress,
		duration / 4.
	)
	_tween.tween_method(
		func(value): node.body_sprite.material.set_shader_parameter('progress', value),
		current_progress,
		damage_progress,
		duration / 4.
	)
	_tween.tween_method(
		func(value): node.body_sprite.material.set_shader_parameter('progress', value),
		damage_progress,
		_inital_progress,
		duration / 4.
	)
