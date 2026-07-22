extends Node

# Player 이동 속도 상수
const SPEED = 200.0

var player: CharacterBody2D
var anim: AnimatedSprite2D

func initialize(owner):
	player = owner
	anim = player.get_node("AnimatedSprite2D")
	
func update(delta):
	var direction = Input.get_vector(
		"ui_left",
		"ui_right",
		"ui_up",
        "ui_down"
	)

	player.velocity = direction * SPEED

	player.move_and_slide()

	player.z_index = int(player.global_position.y + 16)

	update_animation(direction)
	
func update_animation(direction):
	if direction == Vector2.ZERO:
		if anim.animation == "move_front":
			anim.play("stop_front")
		elif anim.animation == "move_back":
			anim.play("stop_back")
		elif anim.animation == "move_right":
			anim.play("stop_right")
		elif anim.animation == "move_left":
			anim.play("stop_left")
		return

	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			anim.play("move_right")
		else:
			anim.play("move_left")
	else:
		if direction.y > 0:
			anim.play("move_front")
		else:
			anim.play("move_back")
