extends Element



func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		if body.elemental_attack == "Fire" and not body.is_elementally_buffed:
			set_enemy_buff_or_weakness(body, "Fire", true)
		elif body.elemental_weakness == "Fire" and not body.is_elementally_weakened:
			set_enemy_buff_or_weakness(body, "Fire", false)
	elif body.name == "Player" and body.elemental_attack != "Water":
		if body.elemental_attack == "Fire" and not body.is_elementally_super_buffed:
			super_buff_player(body)
		elif body.elemental_attack == "Normal":
			set_player_element(body, "Fire")
		elif body.elemental_attack == "Grass":
			set_player_normal(body)
	pickup_cleanup()
