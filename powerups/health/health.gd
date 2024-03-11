extends Powerup

func _on_body_entered(body: Node2D) -> void:
	body.health += 10
	pickup_cleanup()
