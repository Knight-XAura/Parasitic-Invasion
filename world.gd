extends Node2D

const elements = ["Fire", "Water", "Grass", "None"]
const edge_spawn_tiles: Array[Vector2] = [
	Vector2(32, 96), Vector2(32, 160), Vector2(32, 224), Vector2(32, 288), Vector2(32, 352), Vector2(32, 416), Vector2(32, 480), Vector2(32, 544), Vector2(32, 608),
	Vector2(96, 608), Vector2(160, 608), Vector2(224, 608), Vector2(288, 608), Vector2(352, 608), Vector2(416, 608), Vector2(480, 608), Vector2(544, 608), Vector2(608, 608), Vector2(672, 608), Vector2(736, 608), Vector2(800, 608), Vector2(864, 608), Vector2(928, 608), Vector2(992, 608), Vector2(1056, 608), Vector2(1120, 608), Vector2(1184, 608), Vector2(1248, 608),
	Vector2(1248, 544), Vector2(1248, 480), Vector2(1248, 416), Vector2(1248, 352), Vector2(1248, 288), Vector2(1248, 224), Vector2(1248, 160), Vector2(1248, 96), Vector2(1248, 32),
	Vector2(1184, 32), Vector2(1120, 32), Vector2(1056, 32), Vector2(992, 32), Vector2(928, 32), Vector2(864, 32), Vector2(800, 32), Vector2(736, 32), Vector2(672, 32), Vector2(608, 32), Vector2(544, 32), Vector2(480, 32), Vector2(416, 32), Vector2(352, 32), Vector2(288, 32), Vector2(224, 32), Vector2(160, 32), Vector2(96, 32), Vector2(32, 32)
]
const inner_spawn_tiles: Array[Vector2] = [
	Vector2(96, 160), Vector2(96, 224), Vector2(96, 288), Vector2(96, 352), Vector2(96, 416), Vector2(96, 480), Vector2(96, 544),
	Vector2(160, 544), Vector2(160, 480), Vector2(160, 416), Vector2(160, 352), Vector2(160, 288), Vector2(160, 224), Vector2(160, 160), Vector2(160, 96),
	Vector2(224, 96), Vector2(224, 160), Vector2(224, 224), Vector2(224, 288), Vector2(224, 352), Vector2(224, 416), Vector2(224, 480), Vector2(224, 544),
	Vector2(288, 544), Vector2(288, 480), Vector2(288, 416), Vector2(288, 352), Vector2(288, 288), Vector2(288, 224), Vector2(288, 160), Vector2(288, 96),
	Vector2(352, 96), Vector2(352, 160), Vector2(352, 224), Vector2(352, 288), Vector2(352, 352), Vector2(352, 416), Vector2(352, 480), Vector2(352, 544),
	Vector2(416, 544), Vector2(416, 480), Vector2(416, 416), Vector2(416, 352), Vector2(416, 288), Vector2(416, 224), Vector2(416, 160), Vector2(416, 96),
	Vector2(480, 96), Vector2(480, 160), Vector2(480, 224), Vector2(480, 288), Vector2(480, 352), Vector2(480, 416), Vector2(480, 480), Vector2(480, 544),
	Vector2(544, 544), Vector2(544, 480), Vector2(544, 416), Vector2(544, 352), Vector2(544, 288), Vector2(544, 224), Vector2(544, 160), Vector2(544, 96),
	Vector2(608, 96), Vector2(608, 160), Vector2(608, 224), Vector2(608, 288), Vector2(608, 352), Vector2(608, 416), Vector2(608, 480), Vector2(608, 544),
	Vector2(672, 544), Vector2(672, 480), Vector2(672, 416), Vector2(672, 352), Vector2(672, 288), Vector2(672, 224), Vector2(672, 160), Vector2(672, 96),
	Vector2(736, 96), Vector2(736, 160), Vector2(736, 224), Vector2(736, 288), Vector2(736, 352), Vector2(736, 416), Vector2(736, 480), Vector2(736, 544),
	Vector2(800, 544), Vector2(800, 480), Vector2(800, 416), Vector2(800, 352), Vector2(800, 288), Vector2(800, 224), Vector2(800, 160), Vector2(800, 96),
	Vector2(864, 96), Vector2(864, 160), Vector2(864, 224), Vector2(864, 288), Vector2(864, 352), Vector2(864, 416), Vector2(864, 480), Vector2(864, 544),
	Vector2(928, 544), Vector2(928, 480), Vector2(928, 416), Vector2(928, 352), Vector2(928, 288), Vector2(928, 224), Vector2(928, 160), Vector2(928, 96),
	Vector2(992, 96), Vector2(992, 160), Vector2(992, 224), Vector2(992, 288), Vector2(992, 352), Vector2(992, 416), Vector2(992, 480), Vector2(992, 544),
	Vector2(1056, 544), Vector2(1056, 480), Vector2(1056, 416), Vector2(1056, 352), Vector2(1056, 288), Vector2(1056, 224), Vector2(1056, 160), Vector2(1056, 96),
	Vector2(1120, 96), Vector2(1120, 160), Vector2(1120, 224), Vector2(1120, 288), Vector2(1120, 352), Vector2(1120, 416), Vector2(1120, 480), Vector2(1120, 544),
	Vector2(1184, 544), Vector2(1184, 480), Vector2(1184, 416), Vector2(1184, 352), Vector2(1184, 288), Vector2(1184, 224), Vector2(1184, 160), Vector2(1184, 96)
]

var ally_list: Array[CharacterBody2D]
var powerup_list: Array[Area2D]
var enemy_spawn_turn_counter: int = 0
var enemy_spawn_turn_threshold: int = 10
var powerup_spawn_turn_counter: int = 0
var powerup_spawn_turn_threshold: int = 15
var powerup_scenes: Array[PackedScene] = [
	preload("res://powerups/health/health.tscn"),
	preload("res://powerups/elements/fire/fire.tscn"),
	preload("res://powerups/elements/water/water.tscn"),
	preload("res://powerups/elements/grass/grass.tscn")]
var total_kill_count: int = 0:
	set(value):
		enemy_kill_count.text = "Kills: " + str(value)
		total_kill_count = value
var total_moves_count: int = 0:
	set(value):
		moves_count.text = "Moves: " + str(value)
		total_moves_count = value
var game_over_overlay: PackedScene = preload("res://game_over/game_over.tscn")

@export var enemy_scene: PackedScene

@onready var enemies: Node2D = $Enemies
@onready var moveable_area = get_viewport_rect().grow_side(3, -80) # 3 = BOTTOM
@onready var battle_turn_action_timer: Timer = $BattleTurnActionTimer
@onready var player: CharacterBody2D = $Player
@onready var powerups: Node2D = $Powerups
@onready var enemy_kill_count: Label = $/root/World/GUIContainer/VBoxContainer3/HBoxContainer/EnemyKillCount
@onready var moves_count: Label = $GUIContainer/VBoxContainer3/HBoxContainer/MovesCount


func _ready() -> void:
	spawn_enemy()

func _on_player_moved() -> void:
	battle_turn_action_timer.start(5.0)
	move_enemies()
	if enemy_spawn_turn_counter == enemy_spawn_turn_threshold:
		enemy_spawn_turn_counter = 0
		spawn_enemy()
	if powerup_spawn_turn_counter == powerup_spawn_turn_threshold:
		powerup_spawn_turn_counter = 0
		spawn_powerup()
	player.moving = false
	print("NOT MOVING")

func move_enemies() -> void:
	total_moves_count += 1
	enemy_spawn_turn_counter += 1
	powerup_spawn_turn_counter += 1
	for enemy in enemies.get_children():
		if not enemy.battling:
			enemy.move()

func spawn_enemy() -> void:
	var enemy: CharacterBody2D = enemy_scene.instantiate()
	enemy.died.connect(on_enemy_died)
	randomize()
	var enemy_spawn_position: Vector2 = edge_spawn_tiles.pick_random()
	while not is_spawn_position_valid(enemy_spawn_position):
		randomize()
		enemy_spawn_position = edge_spawn_tiles.pick_random()
	enemy.position = enemy_spawn_position
	enemies.add_child(enemy, true)
	ally_list.append(enemy)


func spawn_powerup() -> void:
	var powerup: Area2D = powerup_scenes[randi_range(0, powerup_scenes.size() - 1)].instantiate()
	powerup.picked_up.connect(on_powerup_picked_up)
	randomize()
	var powerup_spawn_position: Vector2 = inner_spawn_tiles.pick_random()
	while not is_spawn_position_valid(powerup_spawn_position):
		randomize()
		powerup_spawn_position = inner_spawn_tiles.pick_random()
	powerup.position = powerup_spawn_position
	powerups.add_child(powerup, true)
	powerup_list.append(powerup)


func is_spawn_position_valid(test_position: Vector2) -> bool:
	if moveable_area.has_point(test_position):
		for enemy in ally_list:
			if enemy.position == test_position:
				return false
		for powerup in powerup_list:
			if powerup.position == test_position:
				return false
		return true
	return false

func _on_battle_turn_action_timer_timeout() -> void:
	move_enemies()
	if player.is_not_normal_element:
			player.element_turn_count += 1
	if player.is_not_normal_element and player.element_turn_count == player.element_turn_threshold:
		player.elemental_weakness = "None"
		player.elemental_attack = "Normal"
		player.animation_element = "normal"
		player.is_not_normal_element = false
		if player.is_elementally_super_buffed:
			player.is_elementally_super_buffed = false
			player.attack = player.original_attack
			player.defense = player.original_defense
			player.critical_hit_chance = player.original_critical_hit_chance
			player.critical_hit_bonus = player.original_critical_hit_bonus
		player.element_turn_count = 0
	player.animated_sprite_2d.play("idle_" + player.animation_element)
	if powerup_spawn_turn_counter == powerup_spawn_turn_threshold:
		powerup_spawn_turn_counter = 0
		spawn_powerup()
	if enemy_spawn_turn_counter == enemy_spawn_turn_threshold:
		enemy_spawn_turn_counter = 0
		spawn_enemy()


func on_enemy_died(who: CharacterBody2D) -> void:
	ally_list.remove_at(ally_list.find(who))
	total_kill_count += 1
	
	
func on_powerup_picked_up(what: Area2D) -> void:
	powerup_list.remove_at(powerup_list.find(what))
