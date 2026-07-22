extends StaticBody2D
class_name Interactable

## [Interactable]
## 플레이어가 근처에서 상호작용(interact) 입력을 하면 애니메이션을 재생하고,
## 필요하면 다른 씬으로 전환하는 범용 스크립트.
## 기존 BoxEntered.gd / BoxOpen.gd / BoxOpen2.gd / SubMap1Game.gd /
## SubMap_1_1_Gate.gd 의 중복 로직을 하나로 통합한 것.
## 씬 에디터의 인스펙터에서 아래 값만 설정하면 됨.

## 상호작용 시 재생할 애니메이션 이름
@export var open_animation: String = "open"
## 상호작용 후 이동할 씬 경로 (비워두면 씬 전환 없음)
@export_file("*.tscn") var target_scene: String = ""
## true면 플레이어가 근처에 있어야만 상호작용 가능 (기존 스크립트들의 공통 동작)
@export var require_proximity: bool = true
## true면 애니메이션이 끝난 뒤 마지막 프레임에서 정지 (기존 BoxOpen.gd 동작)
@export var freeze_last_frame: bool = false

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

var player_near := false
var opened := false

func _ready():
	if freeze_last_frame:
		anim.animation_finished.connect(_on_animation_finished)

func _process(_delta):
	if opened:
		return
	if require_proximity and not player_near:
		return
	if Input.is_action_just_pressed("interact"):
		_open()

func _open():
	opened = true
	anim.play(open_animation)
	if target_scene != "":
		get_tree().change_scene_to_file(target_scene)

func _on_animation_finished():
	if anim.animation == open_animation:
		anim.stop()
		anim.frame = anim.sprite_frames.get_frame_count(open_animation) - 1

func _on_area_2d_body_entered(body):
	if body is CharacterBody2D:
		player_near = true

func _on_area_2d_body_exited(body):
	if body is CharacterBody2D:
		player_near = false
