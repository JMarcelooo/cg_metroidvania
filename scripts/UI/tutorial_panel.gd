extends Panel

@onready var tutorial_panel = $"."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_pressed() -> void:
	get_tree().paused = false # Replace with function body.
	tutorial_panel.hide()
	$Node/Barradialogo.hide()
	$Node/Label2.hide()
	$Node/Label3.hide()
	$Node/Play.hide()
	$Node/Label4.hide()
