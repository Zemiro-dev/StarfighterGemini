extends Node2D


@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var rails_conductor: RailsConductor = $RailsConductor



func _ready() -> void:
	#action_manager.drive(sprite_2d)
	rails_conductor.drive(sprite_2d)
	
