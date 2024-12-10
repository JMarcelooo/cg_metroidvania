extends Panel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $".".visible:
		get_tree().paused = true


func _on_ok_pressed() -> void:
	get_tree().paused = false
	$".".hide()
	$Barradialogo.hide()
	$Ok.hide()
	$Label4.hide()
	$Label5.hide()
