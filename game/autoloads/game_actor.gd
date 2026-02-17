extends Node

enum ActorType { PLAYER, ENEMY, TERRAIN, DESTRUCTIBLE, UNKNOWN }

func get_actor_type(o: Object) -> ActorType:
	if o == null: return ActorType.UNKNOWN
	var actor_type = o.get("actor_type")
	if actor_type != null and ActorType.values().has(actor_type):
		return actor_type
	return ActorType.UNKNOWN
