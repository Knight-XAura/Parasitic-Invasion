extends CanvasLayer


func _input(event: InputEvent) -> void:
	if event is InputEventKey and Input.is_action_just_released("play"):
		get_tree().reload_current_scene()
