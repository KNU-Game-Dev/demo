extends CharacterBody2D
class_name WanderingAnimal

## [WanderingAnimal]
## 무작위 방향으로 배회하는 동물 NPC 공용 스크립트.
## 기존 ChickenMove.gd / CowMove.gd 의 중복 로직을 통합한 것.
## 씬에서 speed / stop_chance 값만 다르게 설정하면 닭, 소 등 어떤 동물에도 재사용 가능.

@export var speed := 80.0
## 매 방향 전환 시 제자리에 멈춰 있을 확률 (0.0 ~ 1.0)
@export var stop_chance := 0.2

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

var direction := Vector2.ZERO

func _ready():
	randomize()
	change_direction()

func _physics_process(_delta):
	velocity = direction * speed
	move_and_slide()

	z_index = int(anim.global_position.y + 16)

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
	direction = Vector2(
		randf_range(-1.0, 1.0),
		randf_range(-1.0, 1.0)
	).normalized()

	if randf() < stop_chance:
		direction = Vector2.ZERO

func _on_timer_timeout():
	change_direction()
