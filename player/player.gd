extends CharacterBody2D

signal player_moved

var battling: bool = false
var battlers: Array[CharacterBody2D] = []
var max_health: int = 100
var health: int = 100:
	set(value):
		health = value
		if value <= 0:
			health_bar.value = 0
			queue_free()
		health_bar.value = value
var attack: int = 2
var defense: int = 1
var elemental_weakness: String = ""
var elemental_attack: String = ""
var has_ranged_attack: bool = false
var is_melee_in_range: bool = false

const MOVE_DISTANCE: int = 64

@onready var world = $/root/World
@onready var health_bar = $/root/World/GUIContainer/GUIControls/VBoxContainer2/HealthBar
@onready var battle_turn: Timer = $BattleTurn


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_action_pressed("move") and not battling:
		velocity = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		if world.moveable_area.has_point(position + velocity * MOVE_DISTANCE):
			position += velocity * MOVE_DISTANCE
		player_moved.emit()


func take_damage(amount: int, element: String) -> void:
	if element == elemental_weakness:
		amount *= 2
	elif element == elemental_attack:
		amount /= 2
	amount -= defense if amount - defense > 0 else 0
	health -= amount


func _on_detection_and_ranged_body_entered(body: Node2D) -> void:
	if has_ranged_attack and not is_melee_in_range and body.name == "Player":
		pass


func _on_detection_and_ranged_body_exited(body: Node2D) -> void:
	pass # Replace with function body.


func _on_melee_body_entered(body: Node2D) -> void:
	is_melee_in_range = true
	battling = true
	battlers.append(body)
	battlers[0].top_level = true
	battle_turn.start()
	


func _on_melee_body_exited(body: Node2D) -> void:
	battlers.remove_at(0)
	if battlers.is_empty():
		is_melee_in_range = false
		battling = false
		battle_turn.stop()
	else:
		battlers[0].top_level = true


func _on_battle_turn_timeout() -> void:
	battlers[0].take_damage(attack, elemental_attack)
