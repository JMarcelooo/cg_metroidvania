extends CollisionShape2D




func _on_transic_area_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://levels/areafinal.tscn")
