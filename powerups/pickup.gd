extends Area2D
class_name Powerup

signal picked_up(what: Area2D)

@onready var world: Node2D = $/root/World

func pickup_cleanup() -> void:
	picked_up.emit(self)
	queue_free()
