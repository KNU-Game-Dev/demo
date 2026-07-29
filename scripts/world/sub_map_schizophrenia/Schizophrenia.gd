# Schizophrenia.gd
extends Node2D

enum ViewMode { A_ONLY, B_ONLY, BOTH }
var current_mode = ViewMode.A_ONLY
var can_toggle = false  # 처음엔 비활성화
@onready var dialogue_label = $UILayer/CanvasLayer/TextureRect/Label

func _ready():
	set_view_mode(ViewMode.A_ONLY)
	
#변수창 인스펙터에서
@export var container_a: Control
@export var container_b: Control
@export var player_a: Node
@export var player_b: Node

# 시점 변경
func set_view_mode(mode: ViewMode):
	current_mode = mode
	match mode:
		ViewMode.A_ONLY:
			container_a.visible = true
			container_a.modulate.a = 1.0
			container_b.visible = false
			_set_player_active(player_a, true)
			_set_player_active(player_b, false)
		ViewMode.B_ONLY:
			container_a.visible = false
			container_b.visible = true
			container_b.modulate.a = 1.0
			_set_player_active(player_a, false)
			_set_player_active(player_b, true)
		ViewMode.BOTH:
			container_a.visible = true
			container_b.visible = true
			container_a.modulate.a = 1.0
			container_b.modulate.a = 0.6  # 겹침 효과
			_set_player_active(player_a, true)
			_set_player_active(player_b, true)
	_update_dialogue(mode)

func _input(event):
	if can_toggle and event.is_action_pressed("toggle_view"): #토글뷰 액션이 눌렸을때-'R키'
		_cycle_view_mode()

func _cycle_view_mode():
	match current_mode:
		ViewMode.A_ONLY:
			set_view_mode(ViewMode.B_ONLY)
		ViewMode.B_ONLY:
			set_view_mode(ViewMode.BOTH)
		ViewMode.BOTH:
			set_view_mode(ViewMode.A_ONLY)
			
# 플레이어 껏다 키기
func _set_player_active(player: Node, active: bool):
	player.process_mode = Node.PROCESS_MODE_INHERIT if active else Node.PROCESS_MODE_DISABLED


func _update_dialogue(mode: ViewMode):
	match mode:
		ViewMode.A_ONLY:
			dialogue_label.text = "현재 상태 : \"너\""
		ViewMode.B_ONLY:
			dialogue_label.text = "현재 상태 : \"나\""
		ViewMode.BOTH:
			dialogue_label.text = "현재 상태 : \"우리\""
