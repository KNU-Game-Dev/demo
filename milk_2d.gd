extends CharacterBody2D

@export var speed := 220.0
@export var max_hp := 10

var hp := max_hp
var direction := Vector2.ZERO
var is_dead := false

@onready var sprite = $AnimatedSprite2D
@onready var timer = $Timer


func _ready():
	randomize()
	add_to_group("enemy")
	change_direction()
	timer.start()
	sprite.play("normal")


func _physics_process(delta):
	if is_dead:
		return

	var collision = move_and_collide(direction * speed * delta)
	if collision:
		change_direction()


func change_direction():
	var angle = randf() * TAU
	direction = Vector2(cos(angle), sin(angle)).normalized()


func _on_timer_timeout():
	change_direction()


func take_damage(amount: int):
	if is_dead:
		return

	hp -= amount
	hp = max(hp, 0)
	update_sprite()

	if hp <= 0:
		die()


func update_sprite():
	if hp <= 0:
		sprite.play("dead")
	elif hp <= max_hp * 0.5:
		sprite.play("damage")
	else:
		sprite.play("normal")


func die():
	is_dead = true
	direction = Vector2.ZERO
	set_physics_process(false)
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://map_HPD2.tscn")
