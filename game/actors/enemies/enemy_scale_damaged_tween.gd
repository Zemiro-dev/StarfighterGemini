extends Node
class_name EnemyScaleDamagedTween

var node: EnemyScale: set = set_node
@export var damage_progress: float = .4
var _inital_progress: float = .2
var _tween: Tween


func set_node(new_node: EnemyScale):
	_inital_progress = .2
	if node:
		var damagable := GameActor.get_damagable(node)
		if damagable:
			var on_damage_taken = damagable.get('on_damage_taken')
			if on_damage_taken:
				if on_damage_taken is Signal:
					on_damage_taken.disconnect(_handle_damage)
	node = new_node
	if node:
		var material: Material = get_material()
		if material: 
			_inital_progress = material.get_shader_parameter('progress')
		var damagable := GameActor.get_damagable(node)
		if damagable:
			var on_damage_taken = damagable.get('on_damage_taken')
			if on_damage_taken:
				if on_damage_taken is Signal:
					on_damage_taken.connect(_handle_damage)


func _handle_damage(_dmg: int):
	tween(node, .05)


func get_material():
	return node.material


func tween(node: EnemyScale, duration: float):
	if _tween != null:
		_tween.kill()
	
	var material: Material = get_material()
	if !material: return
	
	_tween = node.create_tween()
	var current_progress = material.get_shader_parameter('progress')
	_tween.tween_method(
		func(value): material.set_shader_parameter('progress', value),
		current_progress,
		damage_progress,
		duration / 4.
	)
	_tween.tween_method(
		func(value): material.set_shader_parameter('progress', value),
		damage_progress,
		_inital_progress,
		duration / 4.
	)
	_tween.tween_method(
		func(value): material.set_shader_parameter('progress', value),
		current_progress,
		damage_progress,
		duration / 4.
	)
	_tween.tween_method(
		func(value): material.set_shader_parameter('progress', value),
		damage_progress,
		_inital_progress,
		duration / 4.
	)
	_tween.tween_method(
		func(value): material.set_shader_parameter('progress', value),
		current_progress,
		damage_progress,
		duration / 4.
	)
	_tween.tween_method(
		func(value): material.set_shader_parameter('progress', value),
		damage_progress,
		_inital_progress,
		duration / 4.
	)
