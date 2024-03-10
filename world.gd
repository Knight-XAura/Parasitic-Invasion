extends Node2D

const spawn_tiles: Array[Vector2] = [
	Vector2(32, 96), Vector2(32, 160), Vector2(32, 224), Vector2(32, 288), Vector2(32, 352), Vector2(32, 416), Vector2(32, 480), Vector2(32, 544), Vector2(32, 608),
	Vector2(96, 608), Vector2(160, 608), Vector2(224, 608), Vector2(288, 608), Vector2(352, 608), Vector2(416, 608), Vector2(480, 608), Vector2(544, 608), Vector2(608, 608), Vector2(672, 608), Vector2(736, 608), Vector2(800, 608), Vector2(864, 608), Vector2(928, 608), Vector2(992, 608), Vector2(1056, 608), Vector2(1120, 608), Vector2(1184, 608), Vector2(1248, 608),
	Vector2(1248, 544), Vector2(1248, 480), Vector2(1248, 416), Vector2(1248, 352), Vector2(1248, 288), Vector2(1248, 224), Vector2(1248, 160), Vector2(1248, 96), Vector2(1248, 32),
	Vector2(1184, 32), Vector2(1120, 32), Vector2(1056, 32), Vector2(992, 32), Vector2(928, 32), Vector2(864, 32), Vector2(800, 32), Vector2(736, 32), Vector2(672, 32), Vector2(608, 32), Vector2(544, 32), Vector2(480, 32), Vector2(416, 32), Vector2(352, 32), Vector2(288, 32), Vector2(224, 32), Vector2(160, 32), Vector2(96, 32), Vector2(32, 32)
]

@export var enemy_scene: PackedScene
@onready var enemies: Node2D = $Enemies
@onready var moveable_area = get_viewport_rect().grow_side(3, -80) # 3 = BOTTOM
@onready var battle_turn_action_timer: Timer = $BattleTurnActionTimer
@onready var player: CharacterBody2D = $Player

var turn_counter: int = 0

enum ELEMENTS {
	FIRE, WATER, GRASS, NORMAL
}

func _ready() -> void:
	spawn_enemy()

func _on_player_moved() -> void:
	turn_counter += 1
	move_enemies()
	if turn_counter == 10:
		turn_counter = 0
		spawn_enemy()

func move_enemies() -> void:
	for enemy in enemies.get_children():
		if not enemy.battling:
			enemy.move()

func spawn_enemy() -> void:
	var enemy = enemy_scene.instantiate()
	randomize()
	enemy.position = spawn_tiles.pick_random()
	enemies.add_child(enemy)

func _on_turn_pusher_timeout() -> void:
	move_enemies()
