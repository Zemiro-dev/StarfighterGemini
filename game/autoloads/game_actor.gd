extends Node

enum ActorType { PLAYER, ENEMY, TERRAIN, DESTRUCTIBLE, BARRIER, UNKNOWN }

enum ActorMaterial { METAL, ENERGY, UNKNOWN}

func get_actor_type(o: Object) -> ActorType:
	var actor_type = _get_actor_property(o, 'actor_type')
	if ActorType.values().has(actor_type):
		return actor_type
	return ActorType.UNKNOWN


func get_actor_material(o: Object) -> ActorMaterial:
	var actor_material = _get_actor_property(o, 'actor_material')
	if ActorMaterial.values().has(actor_material):
		return actor_material
	return ActorMaterial.UNKNOWN


func _get_actor_property(o: Object, prop_name: String) -> Variant:
	if o == null: return null
	var property = o.get(prop_name)
	if o is Node and property == null:
		var parent = o.get_parent()
		if parent:
			property = parent.get(prop_name)
	return property


func get_damagable(o: Object) -> Object:
	var damagable = o.get('damagable')
	if !damagable:
		if o is Node:
			damagable = o.get_node("Damagable")
	if !damagable:
		if o is Node:
			for child in o.get_children():
				if child is Damagable:
					damagable =	child
	return damagable
	


## Attempts to attack the object's damagable. Returns
## the amount of damage done
func attack(o: Object, damage: int) -> int:
	var damagable = GameActor.get_damagable(o)
			
	if damagable is Object:
		if damagable.has_method('take_damage'):
			return damagable.take_damage(damage)
	return 0


## Checks if this actor can attack and if so applies an attack.
## If 0+ is returned an attack occured and the returned value is
## is the damage dealt. If -1 is returned no attack happened.
func check_and_attack(attacker: Object, target: Object, position: Vector2 = Vector2.ZERO) -> int:
	if attacker.has_method('attack'):
		return attacker.attack(target, position)
	if attacker is Node:
		var parent = attacker.get_parent()
		if parent.has_method('attack'):
			return parent.attack(target, position)
	return -1
