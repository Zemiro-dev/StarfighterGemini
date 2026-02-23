extends Sprite2D
class_name PlayerCannon

@export var controller: PlayerController
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _physics_process(delta: float) -> void:
	var target_direction = controller.get_target_direction().normalized()
	if !target_direction.is_zero_approx():
		rotation = target_direction.angle()


func fire(projectile_pool: NodePool) -> bool:
	var projectiles := projectile_pool.get_nodes(1)
	for projectile in projectiles:
		if projectile is Projectile:
			projectile.fire(global_transform)
	return true
