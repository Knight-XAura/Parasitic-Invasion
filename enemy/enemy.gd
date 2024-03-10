extends CharacterBody2D

var battling: bool = false
var max_health: int = 100
var health: int = 100:
	set(value):
		health = value
		if value <= 0:
			top_level = false
			queue_free()
var attack: int = 4
var defense: int = 2
var elemental_weakness: String = ""
var elemental_attack: String = ""
var has_ranged_attack: bool = randi_range(0, 1)
var is_melee_in_range: bool = false

const MOVE_DISTANCE: int = 64
const MOVE_DIRECTION: Array[Vector2] = [Vector2(1, 0), Vector2(0, 1), Vector2(-1, 0), Vector2(0, -1)]

@onready var world: Node2D = $/root/World
@onready var battle_turn: Timer = $BattleTurn
@onready var battler: CharacterBody2D = $/root/World/Player


func _ready() -> void:
	randomize()
	elemental_attack = ["Fire", "Water", "Grass"].pick_random()
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
	var test = position + velocity * MOVE_DISTANCE
	# need to test if position is another enemy so I can recalculate
	while not world.moveable_area.has_point(test):
		randomize()
		velocity = MOVE_DIRECTION.pick_random()
	position += velocity * MOVE_DISTANCE


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
	battle_turn.stop()


func _on_battle_turn_timeout() -> void:
	battler.take_damage(attack, elemental_attack)
