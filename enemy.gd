class_name MilkCartonMonster
extends CharacterBody2D

## 방 안을 배회하다가 벽/물체에 부딪히면 방향을 바꾸는 비공격형 몬스터.
## 플레이어에게 맞기만 하며, 체력이 절반 이하가 되면 스프라이트가 바뀌고
## 죽으면 GameManager를 통해 다음 맵으로 전환시킨다.

signal died(monster: MilkCartonMonster)

@export var speed: float = 140.0
@export var max_health: int = 10
## 방향을 다시 뽑기까지 걸리는 시간 범위(초). 짧을수록 더 방정맞게 움직임
@export var min_direction_interval: float = 0.15
@export var max_direction_interval: float = 0.45
## 죽었을 때 이동할 맵 씬 경로 (예: "res://maps/next_map.tscn")
@export var next_map_path: String = ""

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $Hitbox

var health: int
var direction: Vector2 = Vector2.ZERO
var is_damaged_phase: bool = false
var _direction_timer: float = 0.0
var _next_direction_change: float = 0.0


func _ready() -> void:
	health = max_health
	_pick_new_direction()
	hitbox.area_entered.connect(_on_hitbox_area_entered)


func _physics_process(delta: float) -> void:
	velocity = direction * speed
	move_and_slide()

	# 벽이나 다른 물체에 부딪히면 새 방향으로 전환
	if get_slide_collision_count() > 0:
		_pick_new_direction()

	# 부딪히지 않아도 짧은 간격으로 계속 방향을 바꿔서 정신없이 움직이게 함
	_direction_timer += delta
	if _direction_timer >= _next_direction_change:
		_pick_new_direction()


func _pick_new_direction() -> void:
	# 8방향(대각선 포함) 중 랜덤이라 더 방정맞고 예측 불가하게 움직임
	var choices := [
		Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT,
		Vector2(1, 1).normalized(), Vector2(-1, 1).normalized(),
		Vector2(1, -1).normalized(), Vector2(-1, -1).normalized(),
	]
	direction = choices[randi() % choices.size()]
	_direction_timer = 0.0
	_next_direction_change = randf_range(min_direction_interval, max_direction_interval)
	_update_animation()


func _update_animation() -> void:
	var prefix := "damaged_" if is_damaged_phase else "normal_"
	if direction == Vector2.LEFT:
		sprite.play(prefix + "walk_left")
	elif direction == Vector2.RIGHT:
		sprite.play(prefix + "walk_right")
	elif direction == Vector2.UP:
		sprite.play(prefix + "walk_up")
	else:
		sprite.play(prefix + "walk_down")


func take_damage(amount: int) -> void:
	if health <= 0:
		return

	health -= amount

	# 체력이 절반 이하로 처음 떨어지는 순간 이미지(애니메이션 세트) 교체
	if not is_damaged_phase and health <= int(max_health / 2.0):
		is_damaged_phase = true
		_update_animation()

	if health <= 0:
		_die()


func _die() -> void:
	died.emit(self)
	if next_map_path != "":
		# GameManager 오토로드가 씬 전환을 담당한다고 가정
		GameManager.change_scene(next_map_path)
	queue_free()


func _on_hitbox_area_entered(area: Area2D) -> void:
	# 플레이어의 공격 판정(Area2D)이 "player_attack" 그룹에 속해있다고 가정
	if area.is_in_group("player_attack"):
		var dmg: int = area.get("damage") if "damage" in area else 1
		take_damage(dmg)
	
		
