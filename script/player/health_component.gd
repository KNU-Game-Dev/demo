extends Node

@export var max_hp := 100
var hp := max_hp

func damage(amount):
	hp -= amount

	if hp <= 0:
		get_parent().queue_free()
