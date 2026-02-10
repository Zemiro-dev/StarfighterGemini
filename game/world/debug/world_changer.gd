extends Node2D

@onready var world_debug_art_button: Button = $MarginContainer/CenterContainer/VBoxContainer/HBoxContainer/WorldDebugArtButton
@onready var debug_player_button: Button = $MarginContainer/CenterContainer/VBoxContainer/HBoxContainer/DebugPlayerButton


var world_debug_art_path = "res://world/debug/world_debug.tscn"
var world_debug_player_path = "res://world/debug/world_debug_player.tscn"


func _ready() -> void:
	world_debug_art_button.pressed.connect(
		func():
			GlobalSignals.request_main_scene_change.emit(world_debug_art_path)
	)
	debug_player_button.pressed.connect(
		func():
			GlobalSignals.request_main_scene_change.emit(world_debug_player_path)
			
	)
