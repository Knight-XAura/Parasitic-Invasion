extends Element



func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.elemental_attack = "Grass"
		body.elemental_weakness = "Fire"
		body.animation_element = "grass"
		body.animated_sprite_2d.play("idle_grass")
	pickup_cleanup()
