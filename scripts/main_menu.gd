extends Node2D

var button_type = null
# Called when the node enters the scene tree for the first time.
func _on_start_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://levels/Hall.tscn")



func _on_quit_pressed() -> void:
	get_tree().quit()
