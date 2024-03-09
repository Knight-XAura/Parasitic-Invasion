extends CharacterBody2D


const MOVE_DISTANCE: int = 128
@onready var position_limiter = get_viewport_rect().grow_side(3, -80)


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_action_pressed("Move"):
		print(position_limiter)
		match event.as_text_physical_keycode():
			"Up":
				velocity = Vector2(0, -1)
			"Down":
				velocity = Vector2(0, 1)
			"Left":
				velocity = Vector2(-1, 0)
			"Right":
				velocity = Vector2(1, 0)
		if position_limiter.has_point(position + velocity * MOVE_DISTANCE):
			position += velocity * MOVE_DISTANCE
