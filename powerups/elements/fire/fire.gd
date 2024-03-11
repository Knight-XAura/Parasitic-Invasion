extends Element



func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.elemental_attack = "Fire"
		body.elemental_weakness = "Water"
	pickup_cleanup()
