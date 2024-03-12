extends CharacterBody2D

signal player_moved

var battling: bool = false
var battlers: Array[CharacterBody2D] = []
var max_health: int = 100
var health: int = 100:
	set(value):
		if value <= 0:
			value = 0
			battle_turn.stop()
			world.battle_turn_action_timer.stop()
			for battler in battlers:
				battler.battle_turn.stop()
			add_sibling(world.game_over_overlay.instantiate(), true)
		if value > max_health:
			value = max_health
		health_bar.value = value
		health_display.text = str(value) + "/" + str(max_health)
		health = value
var attack: int = 2
var defense: int = 1
var critical_hit_chance: int = 5
var critical_hit_bonus: int = 2
var elemental_weakness: String = "Normal"
var elemental_attack: String = "Normal"
var has_ranged_attack: bool = false
var is_melee_in_range: bool = false
var animation_element: String = "normal"

const MOVE_DISTANCE: int = 64

@onready var world = $/root/World
@onready var health_bar = $/root/World/GUIContainer/VBoxContainer3/GUIControls/VBoxContainer2/HealthBar
@onready var health_display: Label = $/root/World/GUIContainer/VBoxContainer3/GUIControls/VBoxContainer2/HealthBar/HealthDisplay
@onready var battle_turn: Timer = $BattleTurn
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _input(event: InputEvent) -> void:
	if event is InputEventKey and Input.is_action_just_pressed("move") and not battling:
		velocity = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		if velocity.abs().round() == Vector2(1, 1):
			return
		if world.moveable_area.has_point(position + velocity * MOVE_DISTANCE):
			position += velocity * MOVE_DISTANCE
		animated_sprite_2d.play("move_" + animation_element)
		match velocity.x:
			-1:
				animated_sprite_2d.flip_h = true
			1:
				animated_sprite_2d.flip_h = false
		player_moved.emit()
		await animated_sprite_2d.animation_finished
		animated_sprite_2d.play("idle_" + animation_element)


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
	is_melee_in_range = true
	battling = true
	battlers.append(body)
	battle_turn.start()
	if world.battle_turn_action_timer.wait_time == 5.0:
		world.battle_turn_action_timer.start(1.0)


func _on_melee_body_exited(body: Node2D) -> void:
	battlers.remove_at(0)
	if battlers.is_empty():
		is_melee_in_range = false
		battling = false
		battle_turn.stop()
		world.battle_turn_action_timer.start(5.0)


func _on_battle_turn_timeout() -> void:
	randomize()
	var damage: int = attack * critical_hit_bonus if randi_range(1, 100) <= critical_hit_chance else attack
	battlers[0].take_damage(damage, elemental_attack)
