extends Node

@onready var game_over_panel: Panel = %GameOverPanel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")


func _on_try_again_pressed() -> void:
	game_over_panel.hide()
	get_tree().change_scene_to_file("res://levels/Hall.tscn")
