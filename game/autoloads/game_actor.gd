extends Node

enum ActorType { PLAYER, ENEMY, TERRAIN, DESTRUCTIBLE, BARRIER, UNKNOWN }

func get_actor_type(o: Object) -> ActorType:
	if o == null: return ActorType.UNKNOWN
	var actor_type = o.get("actor_type")
	if actor_type != null and ActorType.values().has(actor_type):
		return actor_type
	return ActorType.UNKNOWN


## Attempts to attack the object's damagable. Returns
## the amount of damage done
func attack(o: Object, damage: int) -> int:
	var damagable = o.get('damagable')
	if !damagable:
		if o is Node:
			damagable = o.get_node("Damagable")
	if !damagable:
		if o is Node:
			for child in o.get_children():
				if child is Damagable:
					damagable =	child
			
	if damagable is Object:
		if damagable.has_method('take_damage'):
			return damagable.take_damage(damage)
	return 0
