extends Node
class_name Damagable


@export var damagable_stats: DamagableStats = DamagableStats.new()
@onready var health: float = damagable_stats.max_health
