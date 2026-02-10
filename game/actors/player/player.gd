extends CharacterBody2D
class_name Player

@onready var steering: Steering = $Steering


func _physics_process(delta: float) -> void:
	var goal = $Controller.get_goal()
	velocity = steering.steer(velocity, delta)
	move_and_slide()
