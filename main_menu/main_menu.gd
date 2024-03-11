extends Control

var game_world: PackedScene = preload("res://world.tscn")

func _input(event: InputEvent) -> void:
	if event is InputEventKey and Input.is_action_just_released("play"):
		get_tree().change_scene_to_packed(game_world)
