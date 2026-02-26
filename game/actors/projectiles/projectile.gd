extends Area2D
class_name Projectile

@onready var lifetime: Timer = $Lifetime
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var is_available := true: set = set_is_available
@export var stats: ProjectileStats
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
var velocity := Vector2.ZERO


func _ready() -> void:
	if !stats: stats = ProjectileStats.new()
	body_entered.connect(on_body_entered)
	lifetime.timeout.connect(off)


func on_body_entered(body: Node2D) -> void:
	var damage_dealt = GameActor.attack(body, stats.damage)
	off()


func set_is_available(new_value: bool):
	is_available = new_value
	if !is_available:
		process_mode = Node.PROCESS_MODE_INHERIT
	else:
		process_mode = Node.PROCESS_MODE_DISABLED


func fire(_transform: Transform2D) -> void:
	global_transform = _transform
	velocity = Vector2.from_angle(rotation) * 3000.0
	lifetime.start()
	animation_player.play("on")
	reset_physics_interpolation()


func off() -> void:
	velocity = Vector2.ZERO
	animation_player.play("off")


func _physics_process(delta: float) -> void:
	if !velocity.is_zero_approx():
		rotation = velocity.angle()
		var space_state := get_world_2d().direct_space_state
		var query := PhysicsShapeQueryParameters2D.new()
		query.shape = collision_shape_2d.shape
		query.transform = global_transform
		query.collide_with_areas = false
		query.collide_with_bodies = true
		query.collision_mask = collision_mask
		query.motion = velocity * delta
		var result = space_state.cast_motion(query)
		var unsafe = result[1]
		if unsafe >= 1.0:
			global_position += velocity * delta
		else:
			global_position += velocity * delta * unsafe
