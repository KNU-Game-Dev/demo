extends CharacterBody2D

# 캐릭터 이동 속도 상수
const SPEED = 200.0 

@onready var anim = $AnimatedSprite2D

func _physics_process(delta):
	var direction = Vector2.ZERO

	z_index = int(global_position.y + 16)
	
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	elif Input.is_action_pressed("ui_left"):
		direction.x -= 1

	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	elif Input.is_action_pressed("ui_up"):
		direction.y -= 1

	velocity = direction.normalized() * SPEED
	move_and_slide()

	# 애니메이션
	if direction == Vector2.ZERO:
		if anim.animation == "move_front":
			anim.play("stop_front")
		elif anim.animation == "move_back":
			anim.play("stop_back")
		elif anim.animation == "move_right":
			anim.play("stop_right")
		elif anim.animation == "move_left":
			anim.play("stop_left")
	else:
		if abs(direction.x) > abs(direction.y):
			if direction.x > 0:
				anim.play("move_right")
				anim.flip_h = false
			else:
				anim.play("move_left")
				anim.flip_h = false
		else:
			if direction.y > 0:
				anim.play("move_front")
			else:
				anim.play("move_back")
