extends CharacterBody2D

signal died(who: CharacterBody2D)

var battling: bool = false
var max_health: int = 10
var health: int = 10:
	set(value):
		if value <= 0:
			health_bar.value = 0
			died.emit(self)
			queue_free()
		if value > max_health:
			value = max_health
		health_bar.value = value
		health = value
var attack: int = 4
var defense: int = 2
var critical_hit_chance: int = randi_range(1, 10)
var critical_hit_bonus: int = 2
var elemental_weakness: String = ""
var elemental_attack: String = ""
var has_ranged_attack: bool = randi_range(0, 1)
var is_melee_in_range: bool = false

const MOVE_DISTANCE: int = 64
const MOVE_DIRECTION: Array[Vector2] = [Vector2(1, 0), Vector2(0, 1), Vector2(-1, 0), Vector2(0, -1), Vector2(0, 0)]

@onready var world: Node2D = $/root/World
@onready var battle_turn: Timer = $BattleTurn
@onready var battler: CharacterBody2D = $/root/World/Player
@onready var health_bar: ProgressBar = $HealthBar


func _ready() -> void:
	randomize()
	elemental_attack = world.elements.pick_random()
	match elemental_attack:
		"Fire":
			elemental_weakness = "Water"
		"Water":
			elemental_weakness = "Grass"
		"Grass":
			elemental_weakness = "Fire"

func move() -> void:
	randomize()
	velocity = MOVE_DIRECTION.pick_random()
	if not velocity:
		return
	var move_position: Vector2 = position + velocity * MOVE_DISTANCE
	while not is_move_position_valid(move_position):
		randomize()
		velocity = MOVE_DIRECTION.pick_random()
		move_position = position + velocity * MOVE_DISTANCE
	position += velocity * MOVE_DISTANCE
	
func is_move_position_valid(test_position: Vector2) -> bool:
	if world.moveable_area.has_point(test_position):
		for enemy in world.ally_list:
			if enemy.position == test_position or battler.position == test_position:
				return false
		return true
	return false

func take_damage(amount: int, element: String) -> void:
	if element == elemental_weakness:
		amount *= 2
	elif element == elemental_attack:
		amount /= 2
	amount -= defense if amount - defense > 0 else 0
	health -= amount

func _on_detection_and_ranged_body_entered(body: Node2D) -> void:
	if has_ranged_attack and not is_melee_in_range:
		pass


func _on_detection_and_ranged_body_exited(body: Node2D) -> void:
	pass # Replace with function body.

func _on_melee_body_entered(body: Node2D) -> void:
	battling = true
	is_melee_in_range = true
	battle_turn.start()


func _on_melee_body_exited(body: Node2D) -> void:
	is_melee_in_range = false
	battling = false
	battle_turn.stop()

func _on_battle_turn_timeout() -> void:
	randomize()
	var damage: int = attack * critical_hit_bonus if randi_range(1, 100) <= critical_hit_chance else attack
	battler.take_damage(damage, elemental_attack)
