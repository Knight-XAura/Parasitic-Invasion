extends Element



func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.elemental_attack = "Water"
		body.elemental_weakness = "Grass"
	pickup_cleanup()
