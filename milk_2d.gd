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


@onready var audio = $AudioStreamPlayer2D

func take_damage(amount: int, from_position = Vector2.ZERO):
	if is_dead:
		return

	hp -= amount
	hp = max(hp, 0)
	update_sprite()
	flash_hit()
	knockback(from_position)

	if audio.stream:
		audio.play()

	if hp <= 0:
		die()


func flash_hit():
	sprite.modulate = Color(1, 0.3, 0.3)
	await get_tree().create_timer(0.08).timeout
	sprite.modulate = Color(1, 1, 1)


func knockback(from_position: Vector2):
	if from_position == Vector2.ZERO:
		return
	var push_dir = (global_position - from_position).normalized()
	direction = push_dir
	move_and_collide(push_dir * 12)


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
	await screen_shake(0.4, 8.0)
	get_tree().change_scene_to_file("res://map_HPD2.tscn")


func screen_shake(duration: float, strength: float):
	var cam = get_viewport().get_camera_2d()
	if cam == null:
		return

	var original_offset = cam.offset
	var elapsed = 0.0

	while elapsed < duration:
		var progress = elapsed / duration
		var falloff = 1.0 - progress  # 시간 지날수록 흔들림 약해짐
		cam.offset = original_offset + Vector2(
			randf_range(-1, 1) * strength * falloff,
			randf_range(-1, 1) * strength * falloff
		)
		await get_tree().create_timer(0.02).timeout
		elapsed += 0.02

	cam.offset = original_offset
