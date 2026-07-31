extends CharacterBody2D

@export var speed := 220.0
@export var max_hp := 10

var hp := max_hp
var direction := Vector2.ZERO

@onready var sprite = $AnimatedSprite2D
@onready var timer = $DirectionTimer


func _ready():
	randomize()
	change_direction()
	timer.start()
	sprite.play("normal")


func _physics_process(delta):

	var collision = move_and_collide(direction * speed * delta)

	if collision:
		change_direction()


func change_direction():

	var angle = randf() * TAU
	direction = Vector2(cos(angle), sin(angle)).normalized()


func _on_direction_timer_timeout():

	change_direction()
