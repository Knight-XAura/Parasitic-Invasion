extends Area2D

var trail_element: String
@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	match trail_element:
		"FIre":
			sprite_2d.texture = preload("res://enemies/trail/trail_fire.png")
		"Water":
			sprite_2d.texture = preload("res://enemies/trail/trail_water.png")
		"Grass":
			sprite_2d.texture = preload("res://enemies/trail/trail_water.png")
