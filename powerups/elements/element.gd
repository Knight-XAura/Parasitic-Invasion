extends Powerup
class_name Element

func set_player_normal(player: CharacterBody2D) -> void:
	player.element_turn_count = 0
	player.is_not_normal_element = false
	player.elemental_attack = "Normal"
	player.elemental_weakness = "None"
	player.animation_element = "normal"
	if player.is_elementally_super_buffed:
		player.is_elementally_super_buffed = false
		player.attack = player.original_attack
		player.defense = player.original_defense
		player.critical_hit_chance = player.original_critical_hit_chance
		player.criticial_hit_bonsu = player.origianl_critical_hit_bonus
	player.animated_sprite_2d.play("idle_normal")
	
func super_buff_player(player: CharacterBody2D) -> void:
	player.element_turn_count = 0
	player.is_not_normal_element = true
	player.defense *= 2
	player.attack *= 2
	player.critical_hit_chance *= 2
	player.critical_hit_bonus *= 2
	player.is_elementally_super_buffed = true

func set_player_element(player: CharacterBody2D, attack_element: String) -> void:
	player.element_turn_count = 0
	player.is_not_normal_element = true
	player.elemental_attack = attack_element
	match player.elemental_attack:
		"Fire":
			player.animation_element = "fire"
			player.elemental_weakness = "Water"
		"Water":
			player.animation_element = "water"
			player.elemental_weakness = "Grass"
		"Grass":
			player.animation_element = "grass"
			player.elemental_weakness = "Fire"
	player.animated_sprite_2d.play("idle_" + player.animation_element)
	
func set_enemy_buff_or_weakness(enemy: CharacterBody2D, element: String, buff: bool) -> void:
	enemy.is_elementally_buffed_or_weakened = true
	enemy.original_attack = enemy.attack
	if buff:
		enemy.attack *= 2
		enemy.is_elementally_buffed = true
	else:
		enemy.defense /= 2
		enemy.is_elementally_weakened = true
	enemy.element_turn_count = 0
