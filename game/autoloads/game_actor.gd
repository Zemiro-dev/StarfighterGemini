extends Node

enum ActorType { PLAYER, ENEMY, TERRAIN, DESTRUCTIBLE, BARRIER, UNKNOWN }

func get_actor_type(o: Object) -> ActorType:
	if o == null: return ActorType.UNKNOWN
	var actor_type = o.get("actor_type")
	if o is Node and actor_type == null:
		var parent = o.get_parent()
		if parent:
			actor_type = parent.get("actor_type")
	if actor_type != null and ActorType.values().has(actor_type):
		return actor_type
		
	return ActorType.UNKNOWN


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


func check_and_attack(attacker: Object, target: Object) -> int:
	if attacker.has_method('attack'):
		return attacker.attack(target)
	if attacker is Node:
		var parent = attacker.get_parent()
		if parent.has_method('attack'):
			return parent.attack(target)
	return 0
