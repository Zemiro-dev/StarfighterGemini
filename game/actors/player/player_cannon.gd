extends Sprite2D
class_name PlayerCannon

@export var cannon_stats: CannonStats = CannonStats.new()
@export var controller: PlayerController
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var cannon_cooldown: CannonCooldown = $CannonCooldown


func _ready() -> void:
	cannon_cooldown.stats = cannon_stats


func _physics_process(_delta: float) -> void:
	var target_direction = controller.get_target_direction().normalized()
	if !target_direction.is_zero_approx():
		rotation = target_direction.angle()


func fire(projectile_pool: NodePool) -> bool:
	var ready_count := cannon_cooldown.fire(1)
	if ready_count <= 0: 
		return false
	
	var projectiles := projectile_pool.get_nodes(ready_count)
	if projectiles.size() <= 0:
		return false
	for projectile in projectiles:
		if projectile is Projectile:
			projectile.fire(global_transform)
	if animation_player.is_playing():
		animation_player.stop()
	animation_player.play("fire")
	return true
