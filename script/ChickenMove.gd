extends CharacterBody2D

@export var speed := 80.0

@onready var anim = $AnimatedSprite2D

var direction := Vector2.ZERO

func _ready():
	randomize()
	change_direction()

func _physics_process(delta):
	velocity = direction * speed
	move_and_slide()
	
	z_index = int($AnimatedSprite2D.global_position.y + 16)
	
	# 벽에 부딪히면 방향 변경
	if get_slide_collision_count() > 0:
		change_direction()

	# 좌우 반전
	if direction.x > 0:
		anim.flip_h = false
	elif direction.x < 0:
		anim.flip_h = true

	# 애니메이션
	if direction == Vector2.ZERO:
		anim.stop()
	else:
		anim.play("move")

func change_direction():
	# 랜덤 방향
	direction = Vector2(
		randf_range(-1.0, 1.0),
		randf_range(-1.0, 1.0)
	).normalized()

	# 30% 확률로 가만히 있기
	if randf() < 0.2:
		direction = Vector2.ZERO

func _on_timer_timeout():
	change_direction()
