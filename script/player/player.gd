extends CharacterBody2D

# [Player]
# - 입력 전달
# - 컴포넌트 초기화
# - 노드 참조 관리

@onready var movement = $MovementComponent
@onready var attack = $AttackComponent
@onready var health = $HealthComponent
# TODO: menu 구현
@onready var menu = null;

func _ready():
	movement.initialize(self)

func _physics_process(delta):
	#if menu.visible:
		#velocity = Vector2.ZERO
		#return

	movement.update(delta)

func _input(event):
	attack.handle_input(event)

#func _unhandled_input(event):
	#if event.is_action_pressed("open_menu"):
		#menu.visible = !menu.visible
