extends Element



func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.elemental_attack = "Fire"
		body.elemental_weakness = "Water"
		body.animation_element = "fire"
		body.animated_sprite_2d.play("idle_fire")
	pickup_cleanup()
