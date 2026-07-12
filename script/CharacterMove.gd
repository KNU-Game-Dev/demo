extends CharacterBody2D

const SPEED = 200.0

@onready var anim = $AnimatedSprite2D

var menu_scene = preload("res://scene/menu/game_menu.tscn")
var menu

func _ready():
	menu = menu_scene.instantiate()
	menu.visible = false
	get_tree().current_scene.call_deferred("add_child", menu)

func _unhandled_input(event):
	if event.is_action_pressed("open_menu"):
		menu.visible = !menu.visible

func _physics_process(delta):
	# 메뉴가 열려 있으면 플레이어 이동 금지
	if menu.visible:
		velocity = Vector2.ZERO
		move_and_slide()
		return

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
