extends Element



func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		if body.elemental_attack == "Grass" and not body.is_elementally_buffed:
			set_enemy_buff_or_weakness(body, "Grass", true)
		elif body.elemental_weakness == "Grass" and not body.is_elementally_weakened:
			set_enemy_buff_or_weakness(body, "Grass", false)
	elif body.name == "Player" and body.elemental_attack != "Fire":
		if body.elemental_attack == "Grass" and not body.is_elementally_super_buffed:
			super_buff_player(body)
		elif body.elemental_attack == "Normal":
			set_player_element(body, "Grass")
		elif body.elemental_attack == "Water":
			set_player_normal(body)
	pickup_cleanup()
