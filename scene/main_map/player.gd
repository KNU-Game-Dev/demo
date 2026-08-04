extends Node2D

@export var attack_range := 40.0
@export var damage := 2

var player: CharacterBody2D
var anim: AnimatedSprite2D

func initialize(owner):
	player = owner
	anim = player.get_node("AnimatedSprite2D")

func handle_input(event):
	if event.is_action_pressed("attack"):
		attack()

func attack():
	var attack_point = player.global_position + get_facing_offset()
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if enemy.global_position.distance_to(attack_point) <= attack_range:
			if enemy.has_method("take_damage"):
				enemy.take_damage(damage)

func get_facing_offset() -> Vector2:
	match anim.animation:
		"move_right", "stop_right":
			return Vector2(20, 0)
		"move_left", "stop_left":
			return Vector2(-20, 0)
		"move_front", "stop_front":
			return Vector2(0, 20)
		"move_back", "stop_back":
			return Vector2(0, -20)
	return Vector2.ZERO
