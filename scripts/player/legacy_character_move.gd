extends CharacterBody2D

# [LegacyCharacterMove] (구 CharacterMove.gd)
# NOTE: main_map 씬들은 이미 scripts/player/player.gd + MovementComponent 등
# 컴포넌트 기반 구조를 사용 중입니다. 이 스크립트는 sub_map_1 / sub_map_1_1
# 씬이 과거 구조를 그대로 쓰고 있어서 동작 유지를 위해 이름만 옮긴 것입니다.
# 추후 sub_map 씬의 Player 노드도 컴포넌트 구조로 옮기는 것을 권장합니다.

const SPEED = 200.0

@onready var anim = $AnimatedSprite2D

var menu_scene = preload("res://scenes/menu/game_menu.tscn")
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
