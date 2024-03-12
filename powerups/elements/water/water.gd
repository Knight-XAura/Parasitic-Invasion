extends Element



func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.elemental_attack = "Water"
		body.elemental_weakness = "Grass"
		body.animation_element = "water"
		body.animated_sprite_2d.play("idle_water")
	pickup_cleanup()
