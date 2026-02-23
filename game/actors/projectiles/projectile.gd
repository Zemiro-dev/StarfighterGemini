extends Area2D
class_name Projectile

@onready var lifetime: Timer = $Lifetime
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var is_available := true: set = set_is_available
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
var velocity := Vector2.ZERO


func _ready() -> void:
	body_entered.connect(on_body_entered)
	lifetime.timeout.connect(off)

func on_body_entered(body: Node2D) -> void:
	off()


func set_is_available(new_value: bool):
	is_available = new_value
	if !is_available:
		process_mode = Node.PROCESS_MODE_INHERIT
	else:
		process_mode = Node.PROCESS_MODE_DISABLED	


func fire(_transform: Transform2D) -> void:
	reset_physics_interpolation()
	global_transform = _transform
	velocity = Vector2.from_angle(rotation) * 3000.0
	lifetime.start()
	animation_player.play("on")


func off() -> void:
	animation_player.play("off")


func _physics_process(delta: float) -> void:
	rotation = velocity.angle()
	global_position += velocity * delta
