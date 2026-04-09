extends Node2D
class_name PlayerCannonRing

@export var cannon_scene := preload("res://actors/player/components/player_cannon.tscn")
@export var radius: float = 110.0
@export var speed: float = 4 # rotations per second

@export var goal_heading := Vector2.RIGHT: set = _set_goal_heading
@onready var heading := goal_heading
@export_flags_2d_physics var target_mask: int
@export var target_range: float = 1000
var radial_offset := -PI / 2
var cannons: Array[PlayerCannon] = []
var target_global_position := Vector2.ZERO
var use_target := false

func _physics_process(delta: float) -> void:
	heading = Vector2.from_angle(lerp_angle(heading.angle(), goal_heading.angle(), speed * delta))
	update_target_data()
	update_cannon_positions()
	update_cannon_heading()

func add_cannons(num_to_add: int) -> void:
	for i in range(num_to_add):
		var cannon = cannon_scene.instantiate()
		cannons.append(cannon)
		add_child(cannon)


func fire(project_pool: NodePool) -> bool:	
	var attacks := []
	for cannon in cannons:
		attacks.append(cannon.fire(project_pool))
	return attacks.any(func(value): return value)


func update_cannon_positions() -> void:
	for i in range(cannons.size()):
		cannons[i].position = _get_cannon_position(i)

func update_cannon_heading() -> void:
	for i in range(cannons.size()):
		if !use_target:
			cannons[i].heading = goal_heading
		else:
			cannons[i].heading = (target_global_position - cannons[i].global_position).normalized()


func update_target_data() -> void:
	var space_state := get_world_2d().direct_space_state
	var query := PhysicsRayQueryParameters2D.create(global_position, to_global(goal_heading * target_range), target_mask)
	var result := space_state.intersect_ray(query)
	if result.is_empty():
		target_global_position = Vector2.ZERO
		use_target = false
	else:
		target_global_position = result['position']
		use_target = true


func _get_cannon_position(i: int) -> Vector2:
	var starting_angle := heading.angle() + radial_offset
	var cannon_angle := starting_angle + (i * TAU / cannons.size())
	return (Vector2.RIGHT * radius).rotated(cannon_angle)


func _set_goal_heading(new_goal_heading: Vector2):
	goal_heading = new_goal_heading.normalized()
